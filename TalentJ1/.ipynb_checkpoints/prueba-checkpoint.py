import numpy as np
import cv2
from matplotlib import pyplot as plt
import math
import time 




kernel = (np.ones((3,3),np.uint8))

def adjust_gamma(image, gamma=1.0):
	invGamma = 1.0 / gamma
	table = np.array([((i / 255.0) ** invGamma) * 255
		for i in np.arange(0, 256)]).astype("uint8")
	return cv2.LUT(image, table)

for i in range(1,794):
	
	
	
	img = cv2.imread(str(i)+".jpg")

	img = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
	img=adjust_gamma(img,gamma=.6)
	cv2.imshow("gamma",img)
#img = cv2.equalizeHist(img)
#img = cv2.medianBlur(img, 5)
	ret,th2 = cv2.threshold(img,127,255,cv2.THRESH_BINARY)
#th2=cv2.adaptiveThreshold(img,255,cv2.ADAPTIVE_THRESH_GAUSSIAN_C,cv2.THRESH_BINARY,255,0)
	#hist,bins = np.histogram(th2,255,[0,255])
	#a = th2.shape
	#a= a[0]*a[1]
	time.sleep(0.02)
	cv2.imshow("asd",img)
	cv2.imshow("lines", th2)
	#cv2.imshow("gamma",img)
	if cv2.waitKey(1) & 0xFF == ord('q'):
		break

#th2=cv2.adaptiveThreshold(img,255,cv2.ADAPTIVE_THRESH_GAUSSIAN_C,cv2.THRESH_BINARY,11,2)
#th2 = cv2.morphologyEx(th2, cv2.MORPH_CLOSE, kernel)
#img = cv2.medianBlur(th2, 5)

#edges = cv2.Canny(th2,150,255,apertureSize = 5)




#img = cv2.equalizeHist(img)
#hist = cv2.calcHist([img], [0], None, [256], [0, 256])
#plt.plot(hist, color='gray' )

#plt.xlabel('intensidad de iluminacion')
#plt.ylabel('cantidad de pixeles')
#plt.show()


#cv2.imshow("ecualizada",gray2)
cv2.waitKey(0)
cv2.destroyAllWindows()