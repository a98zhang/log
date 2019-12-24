### Generative Learning Algorithms

##### Definition (v.s. Discriminative Learning Algorithms)

* The key of building a generative learning algorithm is to model the  
  $$ {fsdf}
  P(x|y)
  $$

* 

| Learning Algorithm    | Generative       | Discriminant                             |
| --------------------- | ---------------- | ---------------------------------------- |
| modeling distribution | P(x\|y)          | P(y\|x)                                  |
| concept               | find feature     | find classifier (e.g. decision boundary) |
| example               | GDA, Naïve Bayes | Logistic Regression, Perceptron a        |

##### Gaussian Discriminant Analysis

* The key here is to model the *P(x|y)* using a **multivariate gaussian distribution**, i.e., multivariate normal distribution. 

* $$
  y \sim Bernouli(\phi) \\
  x|y=0 \sim \mathcal{N}(\mu_0,\,\Sigma) \\
  x|y=0 \sim \mathcal{N}(\mu_1,\,\Sigma) \\
  $$

  Notice that, x is here assumed to be ==continuous==, real-valued vector

* Therefore, there are four parameters, 

$$
\phi, \mu_0, \mu_1, \Sigma
$$



* **Training** of the model is to learn the parameters, i.e., find the optimal value (maximum likelihood estimate) of the parameters.
  $$
  \phi = \frac{1}{m}\Sigma_{i=1}^{m}1\{y_i=1\}\\
  \mu_0 = \frac{\Sigma_{i=1}^m1\{y^{(i)}=0\}x^{(i)}}{\Sigma_{i=1}^m1\{y^{(i)}=0\}}  \\
  \mu_1 = \frac{\Sigma_{i=1}^m1\{y^{(i)}=1\}x^{(i)}}{\Sigma_{i=1}^m1\{y^{(i)}=1\}}  \\
  \Sigma = \frac1m\Sigma_{i=1}^m(x^{(i)}-\mu_{y^{(i)}})(x^{(i)}-\mu_{y^{(i)}})^T
  $$

* **Predicting** with the model is to use learned parameters to construct two multivariate gaussian distributions
  $$
  P(x|y=0), P(x|y=1)
  $$
  And, using Bayes Rule, calculate 
  $$
  P(y=0|x) = \frac{P(x|y=0)P(y=0)}{P(x)} \\
  P(y=1|x) = \frac{P(x|y=1)P(y=1)}{P(x)}
  $$
  One could then predict using some form of decision boundary

##### Naïve Bayes Classifier

* The key is to make the Naïve Bayes Assumption, that is 
  $$
  given\ y,\ x_i^{'}s\ are\ conditionally\ independent \\
  That\ is,\ P(x_i|y) =P(x_i|y,x_j)\\
  $$
  Notice that, this is different from 

$$
P(x_i) = P(x_i|x_j),\ i.e.x_i^{'}s\ independent
$$





