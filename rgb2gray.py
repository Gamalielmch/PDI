def rgbtogray(rgb):
    import numpy as np
    r, g, b = rgb[:,:,0], rgb[:,:,1], rgb[:,:,2]
    gray = np.round (0.2989 * r + 0.5870 * g + 0.1140 * b)

    return gray