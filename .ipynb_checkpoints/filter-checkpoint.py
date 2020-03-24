import cv2 as cv
import numpy as np

from tkinter import filedialog
from tkinter import *

from matplotlib import pyplot as plt
import math
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter


def selectimage(var):
	root = Tk()
	root.filename =  filedialog.askopenfilename(initialdir = "/",title = "Select file",filetypes = (("jpeg files","*.jpg"),("all files","*.*")))
	img = cv.imread(root.filename)
	if var == 1:
		cv.imshow("image", img)
		return img
	else:
		return img


def agregar_ceros(i,nc):
	tam = i.shape
	vec = np.zeros((tam[0],int(nc)))
	ipad = np.concatenate((vec,i),axis=1)
	ipad = np.concatenate((ipad,vec),axis=1)
	vec = np.zeros((int(nc),tam[1]+2*int(nc)))
	ipad = np.concatenate((vec,ipad),axis=0)
	ipad = np.concatenate((ipad,vec), axis=0)
	return ipad

def padding_2_image(I,n,type):
    import numpy as np
    # I must be gray scale image 
    # n = number of stacks
    # if the n size is 2 n[0]=rows-padding and n[1]=cols-padding 
    # if the n size is 1 then nx-padding = ny-padding
    # Types of padding: "zeros", "circular", "replicate", symmetric". Default=symmetric
    if isinstance(n, int):
        n=[n,n]
    else:
        n=[n[0],n[1]]
    sz=I.shape
    
    if type== "zeros":
        #rows top and bottom
        si=np.zeros((n[0],sz[1]))
        I=np.vstack((si,I))
        I=np.vstack((I,si))
        #cols right and left
        sz=I.shape
        si=np.zeros((sz[0],n[1]))
        I=np.hstack((si,I))
        I=np.hstack((I,si))
    elif type=="circular":
        #rows top
        temp=I[sz[0]-n[0]:sz[0],:]
        I=np.vstack((temp,I))
        #rows bottom
        temp=I[n[0]:2*n[0],:] 
        I=np.vstack((I,temp))
        #cols right
        sz=I.shape
        temp=I[:,sz[1]-n[1]:sz[1]] 
        I=np.hstack((temp,I))
        temp=I[:,n[1]:2*n[1]] 
        I=np.hstack((I,temp))
    elif type=="replicate":
        #rows bottom 
        temp=np.zeros((1,sz[1]))
        temp[0,:]=I[sz[0]-1,:] 
        temp=np.repeat(temp, n[0], axis=0)
        I=np.vstack((I,temp))
        #rows top
        temp=np.zeros((1,sz[1]))
        temp[0,:]=I[0,:]
        temp=np.repeat(temp, n[0], axis=0)
        I=np.vstack((temp,I))
        #cols right
        sz=I.shape
        temp=np.zeros((sz[0],1))
        temp[:,0]=I[:,sz[1]-1] 
        temp=np.repeat(temp, n[1], axis=1)
        I=np.hstack((I,temp))  
        #cols left
        temp=np.zeros((sz[0],1))
        temp[:,0]=I[:,0]
        temp=np.repeat(temp, n[1], axis=1)
        I=np.hstack((temp,I))
    else: 
         #rows bottom
        temp=np.zeros((n[0],sz[1]))
        temp[0:n[0],:]=I[sz[0]-n[0]:sz[0],:]
        temp=np.flip(temp,0)
        I=np.vstack((I,temp))
        #rows top
        temp=np.zeros((n[0],sz[1]))
        temp[0:n[0],:]=I[0:n[0],:]
        temp=np.flip(temp,0)
        I=np.vstack((temp, I))
        #cols right
        sz=I.shape
        temp=np.zeros((sz[0],n[1]))
        temp[:,0:n[1]]=I[:,sz[1]-n[1]:sz[1]]
        temp=np.flip(temp,1)
        I=np.hstack((I,temp))
        #cols right
        temp=np.zeros((sz[0],n[1]))
        temp[:,0:n[1]]=I[:,0:n[1]] 
        temp=np.flip(temp,1)
        I=np.hstack((temp,I))
    return I


def removing_image(I,n):
    import numpy as np
    # I must be gray scale image 
    # if the n size is 2 n[0]=rows-zeros and n[1]=cols-zeros   
    # if the n size is 1 then nx-zeros and ny- zeros are the samen
    if isinstance(n, int):
        n=[n,n]
    else:
        n=[n[0],n[1]]
    sz=I.shape
    I=I[n[0]:sz[0]-n[0],n[1]:sz[1]-n[1]] 
    return I

def iscolor(img):
	if img.ndim > 1 :
		img = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
		return img
	else:
		return img

def medianaf(img,sz):
	agregar = (sz-1)/2
	tam = img.shape
	ipad = agregar_ceros(img,agregar)
	
	for x in range(tam[0]):
	
		d = int(x +agregar)
		for y in range(tam[1]):
			c = int(y + agregar)
		
			it = ipad[d-int(agregar):d+int(agregar)+1,c-int(agregar):c+int(agregar)+1]
		#it = np.sum(it*w)
			ipad[d,c] =np.median(it)
	ipad = ipad.astype(np.uint8)
	ipad = ipad[int(agregar):tam[0],int(agregar):tam[1]]
	return ipad 	



def log(img,sz, sig=.5):
	agregar = (sz-1)/2
	imgni = img.shape
	img = agregar_ceros(img,agregar)

	w = ker(sz,sig,0)
	#print(w.shape)
	ipad = np.zeros((img.shape))
	#ipad = agregar_ceros(img,sz)
	for i in range(imgni[0]):
		d = int(i +agregar)
		for y in range(imgni[1]):
			c = int(y + agregar)
			it = img[d-int(agregar):d+int(agregar)+1,c-int(agregar):c+int(agregar)+1]
			#print(it.shape)
			it = np.sum(it*w)
			ipad[i,y]= it
	ipad = ipad[int(agregar):imgni[0],int(agregar):imgni[1]]
	ipad = ipad-np.amin(ipad)

	ipad = ipad/np.amax(ipad)
	ipad = ipad*255
	ipad = ipad.astype(np.uint8)
	return ipad

def promedio(img,sz):
	agregar = (sz-1)/2
	tam = img.shape
	ipad = agregar_ceros(img,agregar)
	
	for x in range(tam[0]):
	
		d = int(x +agregar)
		for y in range(tam[1]):
			c = int(y + agregar)
		
			it = ipad[d-int(agregar):d+int(agregar)+1,c-int(agregar):c+int(agregar)+1]
		#it = np.sum(it*w)
			ipad[d,c] =(np.sum(it))/sz**2
	ipad = ipad.astype(np.uint8)
	ipad = ipad[int(agregar):tam[0],int(agregar):tam[1]]
	return ipad



def lapalce(img):
	sz = 3
	agregar = (sz-1)/2
	w = [[1,1,1],[1,-8,1],[1,1,1]]
	tam = img.shape
	ipad3 = np.zeros((tam[0],tam[1]))

	for x in range(tam[1]):
	
		d = int(x +agregar)
		for y in range(tam[0]):
			c = int(y + agregar)
		
			it = ipad[c-int(agregar):c+int(agregar)+1,d-int(agregar):d+int(agregar)+1]
			it = np.sum(it*w)
		#print(it)
		#if y ==3:

		#	asd
			ipad3[c,d] =it 
		#print(it)	
	ipad3 = ipad3[int(agregar):tam[0]+int(agregar),int(agregar):tam[1]+int(agregar)]
	gray = img-ipad3
	gray = gray-np.amin(gray)
	gray = gray/np.amax(gray)
	gray = gray*255	
	gray = gray.astype(np.uint8)
	return gray


def loadgray(dir):
	img = cv2.imread(str(dir))
	gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
	return gray

def ker(sz,sig,graph):
	sz =sz
	
	sig=sig
	m=(sz-1)/2
	fil = np.zeros((sz,sz))
	for i in range(0,sz):
		for y in range(0,sz):
			fil[i,y]= (-1/(np.pi*sig**4))*(1 -(((i-m)**2 +(y-m)**2)/(2*sig**2)))*np.exp(((i-m)**2 +(y-m)**2)/(-2*sig**2))


	if graph ==1:
		fig = plt.figure()
		ax = fig.gca(projection='3d')
		X = np.arange(0, sz, 1)
		Y = np.arange(0, sz, 1)
		X, Y = np.meshgrid(X, Y)
		surf = ax.plot_surface(X, Y, fil, cmap=cm.coolwarm,
                       linewidth=0, antialiased=False)
		plt.show()
		return fil
	else:
		return fil

def kernel_gauss (sz,sgm):
    mx=(sz[0]-1)/2 #media en x
    my=(sz[1]-1)/2 #media en y
    print(mx,my)
    w=np.zeros((sz))
    for x in range (sz[0]):
        for y in range (sz[0]):
            w[x,y]= np.exp(((-0.5* ((x-mx)**2 + (y-my)2))) /sgm**2)

            
    return w

def gausiano(img,sz,sgm):
	#sz = 3
	agregar = (sz-1)/2
	w = kernel_gauss(sz,sgm)
	#w = [[1,1,1],[1,-8,1],[1,1,1]]
	tam = img.shape
	ipad3 = np.zeros((tam[0],tam[1]))

	for x in range(tam[1]):
	
		d = int(x +agregar)
		for y in range(tam[0]):
			c = int(y + agregar)
		
			it = ipad[c-int(agregar):c+int(agregar)+1,d-int(agregar):d+int(agregar)+1]
			it = np.sum(it*w)
		#print(it)
		#if y ==3:

		#	asd
			ipad3[c,d] =it 
		#print(it)	
	ipad3 = ipad3[int(agregar):tam[0]+int(agregar),int(agregar):tam[1]+int(agregar)]
	gray = img-ipad3
	gray = gray-np.amin(gray)
	gray = gray/np.amax(gray)
	gray = gray*255	
	gray = gray.astype(np.uint8)
	return gray