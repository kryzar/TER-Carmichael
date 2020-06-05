# Antoine Hugounet
# Experiments.sage

import itertools
import numpy

load("Utilities.sage")

def verifies_Fermat(I, alpha) :
    """
    I : ideal of OK, for some number field K
    alpha : element of OK, K is the same number field
    """

    return (alpha^(I.norm()) - alpha) in I


def find_element_no_fermat_cyclotomic(n, K, coordinates_range) :
    """
    n : integer
    K : cyclotomic field
    coordinates_range : a container containing integers

    Search for algebraic integers alpha such that 
        alpha^{N(nOK)} \not \equiv alpha mod. nOK.
    They are of the form 
        alpha = a_0 + a_1*zeta_p + … + a_{p-1}*zeta_p^{p-1}
    and the integers a_i are chosen in coordinates_range.
    """

    zeta =  K.gen()
    basis = K.integral_basis()
    d =     K.degree()
    nOK =   K.ideal(n)

    coordinates_set = itertools.combinations(coordinates_range, d)
    for coordinates in coordinates_set :
        alpha = numpy.dot(coordinates, basis) # a0 + a1·zeta^1 + …
        if not verifies_Fermat(nOK, alpha) :
            print(coordinates)
            print(str(n) + " is not prime")
