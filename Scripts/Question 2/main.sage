# Antoine Hugounet
# main.sage

def ideal_is_carmichael(I) :
    """
    - I : ideal
    Return True if n is a carmichael integer.
    Return False otherwise.
    We use the Korselt criterion.
    """
    
    prime_dec = I.prime_factors()

    # I is square free
    for P in prime_dec :
        if I.valuation(P) > 1 :
            return False

    # second part of the Korselt Criterion
    NI = Integer(I.norm())
    for P in I.prime_factors() :
        NP = Integer(P.norm())
        if not (NP - 1).divides(NI - 1) :
            return False

    return True

def int_below_512461_is_carmichael(n) :
    """
    - n : int
    Return True if n is a carmichael integer.
    Return False otherwise.
    We use a list to save calculations time.
    """
    
    # from https://oeis.org/A002997
    carmichael_numbers = [561, 1105, 1729, 2465, 2821, 6601, 8911, 10585,
            15841, 29341, 41041, 46657, 52633, 62745, 63973, 75361, 101101,
            115921, 126217, 162401, 172081, 188461, 252601, 278545, 294409,
            410041, 449065, 488881, 512461]
    
    return n in carmichael_numbers

def find_carmichael_ideal(gen_range, bound, condition) :
    """
    - gen_range (IntegerRange) : for the squarefree integers d 
    such that K = Q(sqrt{d})
    - bound (int) : the positive integers generators of the ideal
    - condition : a function which tests an arbitrary condition on n,
    for exemple if we want n to be the product of three distinct primes.
    are below this bound
    Rreturn a list of couples (d, n) where d is a squarefree integer
    and n is a non-Carmichael number which generates a Carmichael ideal
    in the integers ring of Q(sqrt(d)).
    """

    if (bound > 512461) :
        raise Exception("To save calculation time, n must be <= 512461.")

    results_file = open("Results.txt", "w")
    meta = ("d in [" + str(gen_range[0]) + ", " + str(gen_range[-1]) + "]\n")
    meta += ("n in [2, " + str(bound - 1) + "]\n")  
    meta += ("Condition on n : " + condition.__name__ + "\n\n")
    results_file.write(meta)

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

# tests
K.<a> = QuadraticField(23)
I = K.ideal(77)
assert ideal_is_carmichael(I) == False
K.<a> = QuadraticField(11)
I = K.ideal(35)
assert ideal_is_carmichael(I) == True
