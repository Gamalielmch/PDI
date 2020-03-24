import numpy as np
import cv2
from matplotlib import pyplot as plt
import math

img = cv2.imread("466.jpg")
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

mini = np.amin(gray)
maxi = np.amax(gray)

pi, bins = np.histogram(img.ravel(),np.arange(256))
pi = pi/np.sum(pi)
bins = np.linspace(0,255,255)
#plt.plot(bins,pi)
#plt.show()
sgm2 = []
for i in range(mini, maxi):
	w0 =  np.sum(pi[0:i])+.0001
	w1 =  (1-w0)+0.0000001
	miu0 = (np.sum((np.arange(i))*pi[0:i]))/w0
	miu1 = (np.sum((np.arange(i+1,maxi))*pi[i+1:maxi]))/w1
	#print(miu0,miu1)
	sgm2 =np.append(sgm2, w0*w1*(miu0-miu1)**2)
	#print(sgm2)
#print(sgm2)
umbral = np.argmax(sgm2)
ret,thresh1 = cv2.threshold(gray,umbral,255,cv2.THRESH_BINARY)
#cv2.imshow(thresh1)
print(umbral)
plt.plot(sgm2)
plt.show()
cv2.imshow("oka", thresh1)
cv2.waitKey(0)
cv2.destroyAllWindows()