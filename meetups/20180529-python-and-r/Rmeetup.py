
# coding: utf-8

# # RPy2

# In[ ]:

import rpy2.rinterface
rpy2.rinterface.set_initoptions(('rpy2', '--verbose', '--no-save'))

from rpy2.robjects.packages import importr
base = importr('base')
print(base._libPaths())

import rpy2.robjects as ro
ro.r('''.libPaths('C:/Users/Mahdi/Anaconda2/Lib/R/library')''')


# In[ ]:

ro.r('x=c()')
ro.r('x[1]=22')
ro.r('x[2]=44')
print(ro.r('x'))
type(ro.r('x'))


# ## ggplot2

# In[ ]:

from numpy import *
import scipy as sp
from pandas import *
import rpy2.robjects as ro
import pandas.rpy.common as com
get_ipython().magic(u'matplotlib inline')
import math, datetime
import rpy2.robjects.lib.ggplot2 as ggplot2
import rpy2.robjects as ro
from rpy2.robjects.packages import importr
base = importr('base')
datasets = importr('datasets')





grdevices = importr('grDevices')
grdevices.png(file="Rpy2ggplot2.png", width=512, height=512)
#mtcars = datasets.data.fetch('mtcars')['mtcars']
mtcars=com.load_data('mtcars')
mtcars=com.convert_to_r_dataframe(mtcars)
pp = ggplot2.ggplot(mtcars) +      ggplot2.aes_string(x='wt', y='mpg', col='factor(cyl)') +      ggplot2.geom_point() +      ggplot2.geom_smooth(ggplot2.aes_string(group = 'cyl'),method = 'lm')
pp.plot()
grdevices.dev_off()


# ##  lattice 

# In[ ]:

from rpy2 import robjects
from rpy2.robjects import Formula, Environment
from rpy2.robjects.vectors import IntVector, FloatVector
from rpy2.robjects.lib import grid
from rpy2.robjects.packages import importr

# The R 'print' function
rprint = robjects.globalenv.get("print")
stats = importr('stats')
grdevices = importr('grDevices')
base = importr('base')
datasets = importr('datasets')


# In[ ]:

lattice = importr('lattice')


# In[ ]:

xyplot = lattice.xyplot


# In[ ]:

datasets = importr('datasets')
mtcars = datasets.__rdata__.fetch('mtcars')['mtcars']
formula = Formula('mpg ~ wt')
formula.getenvironment()['mpg'] = mtcars.rx2('mpg')
formula.getenvironment()['wt'] = mtcars.rx2('wt')

# p = lattice.xyplot(formula)
# rprint(p)


# In[ ]:

p = lattice.xyplot(formula, groups = mtcars.rx2('cyl'))
rprint(p)


# In[ ]:

tmpenv = datasets.__rdata__.fetch("volcano")
volcano = tmpenv["volcano"]

p = lattice.wireframe(volcano, shade = True,
                      zlab = "",
                      aspect = FloatVector((61.0/87, 0.4)),
                      light_source = IntVector((10,0,10)))
rprint(p)


# In[ ]:

reshape2 = importr('reshape2')
dataf = reshape2.melt(volcano)
dataf = dataf.cbind(ct = lattice.equal_count(dataf.rx2("value"), number=3, overlap=1/4))
p = lattice.wireframe(Formula('value ~ Var1 * Var2 | ct'), 
                      data = dataf, shade = True,
                      aspect = FloatVector((61.0/87, 0.4)),
                      light_source = IntVector((10,0,10)))
rprint(p, nrow = 1)


# # pyRserve

# In[ ]:

import pyRserve
conn = pyRserve.connect(host='localhost')
conn


# ## simple operations

# In[ ]:

conn.close()
conn


# In[ ]:

conn.connect()
conn


# In[ ]:

conn.isClosed


# In[ ]:

conn.eval('3 + 5')


# In[ ]:

conn.eval('3 + 5', atomicArray=True)


# In[ ]:

conn.voidEval('doubleit <- function(x) { x*2 }')


# In[ ]:

conn.eval('doubleit(2)')


# In[ ]:

my_r_script = '''
squareit <- function(x)
  { x**2 }
squareit(4)
'''


# In[ ]:

conn.eval(my_r_script)


# In[ ]:

res = conn.eval('t.test(c(1,2,3,1),c(1,6,7,8))')


# In[ ]:

res


# In[ ]:

import numpy
conn.r.sapply(numpy.array([-1,2,3]), conn.r.abs)


# In[ ]:

conn.close()


# In[ ]:

conn.r.sapply(numpy.array([-1,2,3]), conn.r.abs)


# In[ ]:

conn.connect()


# In[ ]:

conn.voidEval('double <- function(x) { x*2 }')
conn.r.sapply(numpy.array([1, 2, 3]), conn.r.double)


# In[ ]:

def double(v): return v*2
conn.r.sapply(array([1, 2, 3]), double)


# ## Script

# In[ ]:

#import pyRserve
import pyRserve

#open pyRserve connection
conn = pyRserve.connect(host='localhost', port=6311)

#load your rscript into a variable (you can even write functions)
test_r_script = '''
mileage<-c(0,4,8,12,16,20,24,28,32)
groove<-c(394.33,329.5,291,255.17,229.33,204.83,179,163.83,150.33)
Tread<-data.frame(mileage,groove)
plot(Tread, pch=16 , main = "Scatter plot of Mileage vs Groove Depth")
                '''

#do the connection eval
conn.eval(test_r_script)
# closing the pyRserve connection
#conn.close()

