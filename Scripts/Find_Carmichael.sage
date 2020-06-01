load("Is_Carmichael.sage")

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
    results_file = open("Results_Find_Carmichael.txt", "w")
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
            
            if not int_below_512461_is_carmichael(n) and ideal_verifies_Korselt_criterion(I) : 
                output = "(d, n) = (" + str(d) + ", " + str(n) + ")\n"
                results_file.write(output)

    results_file.close()
