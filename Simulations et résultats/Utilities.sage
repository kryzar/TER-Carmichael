# Antoine Hugounet
# Utilities.sage

import time

# from https://oeis.org/A002997
CARMICHAEL_NUMBERS_BELOW_512461 = [561, 1105, 1729, 2465, 2821, 6601, 8911, 
    10585, 15841, 29341, 41041, 46657, 52633, 62745, 63973,
    75361, 101101, 115921, 126217, 162401, 172081, 188461,
    252601, 278545, 294409, 410041, 449065, 488881, 512461]

HOWE = 17 * 31 * 41 * 43 * 89 * 97 * 167 * 331

LIST_CYCLOTOMIC_FIELDS = [CyclotomicField(7),
        CyclotomicField(101),
        CyclotomicField(199),
        CyclotomicField(293)]

def KorseltCriterion_Ideal(I) :
    """
    I : ideal in a number field integer ring
    """
    
    prime_dec = I.prime_factors()

    # I is square free
    for p in prime_dec :
        if I.valuation(p) > 1 :
            return False

    # second part of the Korselt Criterion
    NI = Integer(I.norm())
    for p in I.prime_factors() :
        Np = Integer(p.norm())
        if not (Np - 1).divides(NI - 1) :
            return False

    return True

def KorseltCriterion_Int(n) :
    """
    n : Integer
    """

    if not n.is_squarefree() :
        return False

    for p in n.prime_factors() :
        if not (p - 1).divides(n - 1) :
            return False

    return True


def PrimeFactors_1mod5(n) :
    """
    Return True if the prime factors of n 
    are 1 mod. 5, False otherwise.
    """

    for p in n.prime_factors() :
        if Mod(p, 5) != 1 :
            return False

    return True


def time_KorseltCriterion_Ideal(n, fields_list) :
    """
    Given n an integer and fields_list a list of fields,
    print the time required to compute KorseltCriterion_Ideal
    for n and each field in fields_list.
    """

    for K in fields_list :
        nOK = K.ideal(n)
        start = time.clock()
        KorseltCriterion_Ideal(nOK)
        elapsed_time = time.clock() - start
        print("===")
        print(K)
        print(elapsed_time)


# Unit tests
def unit_tests() :
    K.<a> = QuadraticField(23)
    I = K.ideal(77)
    assert KorseltCriterion_Ideal(I) == False
    K.<a> = QuadraticField(11)
    I = K.ideal(35)
    assert KorseltCriterion_Ideal(I) == True
    for n in CARMICHAEL_NUMBERS_BELOW_512461 :
        assert KorseltCriterion_Int(n) == True

    for n in [4, 6, 10, 27, 46, 51] :
        assert KorseltCriterion_Int(n) == False

unit_tests()
