def padding_image(I,n,type):
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
        temp=np.flip(temp,1)
        I=np.vstack((I,temp))
        #rows top
        temp=np.zeros((n[0],sz[1]))
        temp[0:n[0],:]=I[0:n[0],:]
        temp=np.flip(temp,1)
        I=np.vstack((temp, I))
        #cols right
        sz=I.shape
        temp=np.zeros((sz[0],n[1]))
        temp[:,0:n[1]]=I[:,sz[1]-n[1]+1] 
        temp=np.flip(temp,0)
        I=np.vstack((I,temp))
        #cols right
        temp=np.zeros((sz[0],n[1]))
        temp[:,0:n[1]]=I[:,0:n[1]+1] 
        temp=np.flip(temp,0)
        I=np.vstack((temp,I))
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