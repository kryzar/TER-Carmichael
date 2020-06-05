# Antoine Hugounet
# Algorithms.sage

# both for find_element_no_fermat_in_OK
import itertools
import numpy

load("Utilities.sage")


def Fermat_test_number_field(n, K, coordinates_range) :
    """
    n : integer
    K : cyclotomic field
    coordinates_range : a container containing integers

    Search for algebraic integers alpha such that 
        alpha^{N(nOK)} \not \equiv alpha mod. nOK.
    They are of the form 
        alpha = a_0 + a_1*theta + … + a_{p-1}*theta^{p-1}
    and the integers a_i are chosen in coordinates_range.
    """

    integer_basis = K.integral_basis()
    nOK =           K.ideal(n)
    N =             nOK.norm()

    # make the set of all possible coordoninates with
    # elements in coordinates_range
    coordinates_set = itertools.combinations_with_replacement(
            coordinates_range, K.degree())
    for coordinates in coordinates_set :
        alpha = numpy.dot(coordinates, integer_basis) # a0 + a1·theta^1 + …
        verifies_Fermat = (alpha^N - alpha) in nOK
        if not verifies_Fermat :
            print("alpha = " + str(coordinates) + " does not verify "\
                + "the Fermat property")

 
def CarmichaelInQzeta5_NotCarmichaelInt_PrimeFactorsNot1mod5(bound) :
    """ 
    Find all integers (they may not exist) in [[2, bound]]
    which are Carmichael in Q(zeta5) but there prime factors
    are not 1 mod. 5.
    """

    outfile = open("CarmichaelInQzeta5_NotCarmichaelInt_PrimeFactorsNot1mod5.txt", "w")
    outfile.write("search for n in [[2, " + str(bound) + "]]\n\n")

    Qzeta5 = QuadraticField(5)
    nOK = Qzeta5.ideal(0)
    
    for n in IntegerRange(2, bound + 1) :
        if not PrimeFactors_1mod5(n) \
                and not n.is_prime() \
                and KorseltCriterion_Ideal(Qzeta5.ideal(n)) :
            output = str(n) + " is Carmichael in Q(zeta5)" \
                    + ", its prime factors are not 1 mod. 5.\n"
            output += str(n) + " is carmichael in Q: " + \
                    str(KorseltCriterion_Int(n)) + "\n\n"

            outfile.write(output)

    outfile.close()


def Carmichael_cyclotomic(n, borne_q) :
    """
    Given an integer n, for each cyclotomic field Q(zetaq) with 
    q in [[3, borne_q]] and if q and n are coprime, tell if 
    n is Carmichael in Q(zetaq) or not
    """

    outfile = open(str(n) + "_cyclotomic.txt", "w")
    is_or_isnot = ""

    for q in prime_range(3, borne_q) :
        if gcd(n, q) == 1 :
            K = CyclotomicField(q)
            nOK = K.ideal(n)

            output = str(n) + " is Carmichael in Q(zeta" + str(q) + "): " \
                    + str(KorseltCriterion_Ideal(nOK)) \
                    + ", " + str(n) + " and " + str(q) + " are coprime\n"
            outfile.write(output)

    outfile.close()


def Carmichael_quadratic(n, gen_range) :
    """
    Given an integer n, find quadratic fields Q(sqrt(d))
    where d is squarefree and in gen_range such that n is not Carmichael in
    the integers ring of this field.
    """

    outfile = open(str(n) + "_quadratic.txt", "w")
    is_or_isnot = ""

    for d in gen_range :
        if d.is_squarefree() and \
                d not in [-1, 0, 1] and \
                gcd(n, d) == 1 :
            K = QuadraticField(d)
            nOK = K.ideal(n)

            output = str(n) + " is Carmichael in Q(sqrt(" + str(d) + ")): " \
                    + str(KorseltCriterion_Ideal(nOK)) \
                    + ", " + str(n) + " and Disc(Q(sqrt(" + str(d) + "))) are coprime\n"
            outfile.write(output)

    outfile.close()


def IntBelow512461IsNotCarmichael_nOKIsCarmichael(gen_range, bound, condition) :
    """
    Find all couples (d, n) such that n is not a Carmichael number but generates
    a Carmichael ideal in the integer ring of the quadratic field Q(\sqrt{d}).
    n is chosen in [[2, bound]] and d is chosen in the interval given by gen_range.

    - gen_range (IntegerRange) : the square free integers d such that
    K = Q(\sqrt{d}) are chosen in the integer interval given by gen_range
    - bound (int) : the generators of the ideal are chosen in [[2, bound]] with
    bound < 512461
    - condition : a function which tests an arbitrary condition on n,
    for exemple if we want n to be the product of three distinct primes.
    If you do not want any condition on n, simply define condition as
    def no_condition(n) : return True.
    Return an outfile with couples (d, n) where d is a squarefree integer
    and n is a non-Carmichael number which generates a Carmichael ideal
    in the integers ring of Q(sqrt(d)).
    """

    if not n <= 512461 :
        raise Exception("n must be <= 512461")

    # write meta stuff in the outfile
    outfile = open("IntBelow512461IsNotCarmichael_nOKIsCarmichael.txt", "w")
    meta = ("d in [" + str(gen_range[0]) + ", " + str(gen_range[-1]) + "]\n")
    meta += ("n in [2, " + str(bound - 1) + "]\n")  
    meta += ("Condition on n : " + condition.__name__ + "\n\n")
    outfile.write(meta)

    # this is where the fun begins
    qf_generators = [d for d in gen_range if d!=1 and d.is_squarefree()]
    ideal_generators = [n for n in IntegerRange(2, bound) if condition(n)]
    for d in qf_generators :
        K = QuadraticField(d)

        for n in ideal_generators :
            I = K.ideal(n)
            
            if not n in CARMICHAEL_NUMBERS_BELOW_512461 \
                    and KorseltCriterion_Ideal(I) : 
                output = "(d, n) = (" + str(d) + ", " + str(n) + ")\n"
                outfile.write(output)

    outfile.close()
