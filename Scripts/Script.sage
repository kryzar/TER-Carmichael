# Antoine Hugounet
# Script.sage
# This SageMath script finds number that generate a Carmichael ideal
# in the integer ring of a quadratic field but tht are not Carmichael numbers.
# Usage: open SageMath in the directory of this file, run load("Script.sage")
# and call the function find_carmichael_ideal.

def ideal_is_carmichael(I) :
    """
    - I : ideal in a number field integer ring
    Return True if n is a carmichael integer and False otherwise.

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
    
    # from https://oeis.org/A002997
    carmichael_numbers = [561, 1105, 1729, 2465, 2821, 6601, 8911, 10585,
            15841, 29341, 41041, 46657, 52633, 62745, 63973, 75361, 101101,
            115921, 126217, 162401, 172081, 188461, 252601, 278545, 294409,
            410041, 449065, 488881, 512461]
    
    return n in carmichael_numbers

def find_carmichael_ideal_below_512461(gen_range, bound, condition) :
    """
    Find all couples (d, n) such that n is not a Carmichael number but generates
    a Carmichael ideal in the integer ring of the quadratic field Q(\sqrt{d}).
    n is chosen in [[2, bound]] and d is chosen in the interval given by gen_range.

    - gen_range (IntegerRange) : the square free integers d such that
    K = Q(\sqrt{d}) are chosen in the integer interval given by gen_range
    - bound (int) : the generators of the ideal are chosen in [[2, bound]]
    - condition : a function which tests an arbitrary condition on n,
    for exemple if we want n to be the product of three distinct primes.
    If you do not want any condition on n, simply define condition as
    def no_condition(n) : return True.
    Return a Results.txt file with couples (d, n) where d is a squarefree integer
    and n is a non-Carmichael number which generates a Carmichael ideal
    in the integers ring of Q(sqrt(d)).
    """

    # write meta stuff in Results.txt
    results_file = open("Results.txt", "w")
    meta = ("d in [" + str(gen_range[0]) + ", " + str(gen_range[-1]) + "]\n")
    meta += ("n in [2, " + str(bound - 1) + "]\n")  
    meta += ("Condition on n : " + condition.__name__ + "\n\n")
    results_file.write(meta)

    # this is where the fun begins
    qf_generators = [d for d in gen_range if d!=1 and d.is_squarefree()]
    ideal_generators = [n for n in IntegerRange(2, bound) if condition(n)]
    for d in qf_generators :
        K.<a> = QuadraticField(d)

        for n in ideal_generators :
            I = K.ideal(n)
            
            if not int_below_512461_is_carmichael(n) and ideal_is_carmichael(I) : 
                output = "(d, n) = (" + str(d) + ", " + str(n) + ")\n"
                results_file.write(output)

    results_file.close()

# Unit tests
K.<a> = QuadraticField(23)
I = K.ideal(77)
assert ideal_is_carmichael(I) == False
K.<a> = QuadraticField(11)
I = K.ideal(35)
assert ideal_is_carmichael(I) == True
