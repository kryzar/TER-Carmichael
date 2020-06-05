# Antoine Hugounet
# Experiments.sage

import itertools
import numpy

load("Utilities.sage")

def find_element_no_fermat_in_OK(n, K, coordinates_range) :
    """
    n : integer
    K : cyclotomic field
    coordinates_range : a container containing integers

    Search for algebraic integers alpha such that 
        alpha^{N(nOK)} \not \equiv alpha mod. nOK.
    They are of the form 
        alpha = a_0 + a_1*theta + … + a_{p-1}*theta^{p-1}
    and the integers a_i are chosen in coordinates_range.

    As of now, works only when K = Q(theta), OK = Z[theta] and
    OK is of rank [K : Q] over Z. This is the case for quadratic
    and cyclotomic fields.
    """

    basis = K.integral_basis()
    d =     K.degree()
    nOK =   K.ideal(n)
    N =     nOK.norm()

    coordinates_set = itertools.combinations_with_replacement(
            coordinates_range, d)
    for coordinates in coordinates_set :
        alpha = numpy.dot(coordinates, basis) # a0 + a1·theta^1 + …
        verifies_Fermat = (alpha^N - alpha) in nOK
        if not verifies_Fermat :
            print("alpha = " + str(coordinates) + " does not verify "\
                + "the Fermat property")
