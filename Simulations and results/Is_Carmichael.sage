# Antoine Hugounet
# Is_Carmichael.sage

# from https://oeis.org/A002997
Carmichael_numbers = [561, 1105, 1729, 2465, 2821, 6601, 8911, 
    10585, 15841, 29341, 41041, 46657, 52633, 62745, 63973,
    75361, 101101, 115921, 126217, 162401, 172081, 188461,
    252601, 278545, 294409, 410041, 449065, 488881, 512461]

def ideal_verifies_Korselt_criterion(I) :
    """
    - I : ideal in a number field integer ring

    We use the Korselt criterion.
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

def int_below_512461_is_carmichael(n) :
    """
    - n : int
    Return True if n is a carmichael integer and False otherwise.

    We use a list to save calculations time.
    """

    if (n > 512461) :
        raise Exception("n must be <= 512461.")
    
    return n in Carmichael_numbers

# Unit tests
K.<a> = QuadraticField(23)
I = K.ideal(77)
assert ideal_verifies_Korselt_criterion(I) == False
K.<a> = QuadraticField(11)
I = K.ideal(35)
assert ideal_verifies_Korselt_criterion(I) == True
