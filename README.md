# Ensemble-of-Saliency-Cues
A saliency dectetion method on 360-degree images.
This implementation calls two deep learning methods written in Python.

## Requirements:
[Python](https://www.python.org/download/releases/2.7/) 2.7

[Theano](http://deeplearning.net/software/theano/install_windows.html) 0.9

[Keras](https://keras.io/) 1.2.0 (Note: Keras changed its API in the latest version so the version must be 1.2.0)

Other miscellaneous [requirements](https://github.com/imatge-upc/saliency-salgan-2017/blob/master/requirements.txt)

Note: The codes of the 2 deep models have been modified so the codes from the original sources won't work here.
## Usage:
In Matlab, type:
```
imgLoc = 'p31.jpg';
s = predictSaliency(imgLoc);
```

or 
```
imgLoc = 'p31.jpg';
s = predictSaliency(imgLoc,true); //display the saliency image
```

or 
```
imgLoc = 'p31.jpg';
s = predictSaliency(imgLoc,true,true); //display and save the saliency image
```

## Credits:
This implementation is based on two deep learning methods: [Saliency Attentive Model](https://github.com/marcellacornia/sam) and [Visual Saliency Prediction with Generative Adversarial Networks](https://github.com/imatge-upc/saliency-salgan-2017). Please refer to the original papers for more details.
