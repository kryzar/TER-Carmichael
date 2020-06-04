# Antoine Hugounet
# Algorithms.sage

load("Is_Carmichael.sage")
HOWE = 17 * 31 * 41 * 43 * 89 * 97 * 167 * 331

def Carmichael_cyclotomic(n, borne_q) :
    """
    Given an integer n, for each cyclotomic field Q(zetaq) with 
    q in [[3, borne_q]] and if q and n are coprime, tell if 
    n is Carmichael in Q(zetaq) or not
    """

    outfile = open("Results_" + str(n) + "_cyclotomic.txt", "w")
    is_or_isnot = ""

    for q in prime_range(3, borne_q) :
        if gcd(n, q) == 1 :
            K = CyclotomicField(q)
            nOK = K.ideal(n)

            if ideal_verifies_Korselt_criterion(nOK) :
                is_or_isnot = " is " 
            else :
                is_or_isnot = " is not "

            output = str(n) + is_or_isnot + "Carmichael in " \
                    + "Q(zeta" + str(q) + "), " \
                    + str(n) + " and " + str(q) + " are coprime\n"
            outfile.write(output)

    outfile.close()


def Carmichael_not_Carmichael_in_quad_field(gen_range) :
    """
    For every Carmichael number below 512461, find quadratic fields Q(sqrt(d))
    where d is squarefree and in gen_range such that n is not Carmichael in
    the integers ring of this field.
    """

    # meta info
    outfile = open("Results_Carmichael_not_Carmichael_in_quad_field.txt", "w")
    meta = ("d in [" + str(gen_range[0]) + ", " + str(gen_range[-1]) + "]\n")
    outfile.write(meta)

    qf_generators = [d for d in gen_range if d!=1 and d.is_squarefree()]
    for n in Carmichael_numbers :
        for d in qf_generators :
            K = QuadraticField(d)
            nOK = K.ideal(n)
            if not ideal_verifies_Korselt_criterion(nOK) : 
                output = str(n) + " is not Carmichael in Q(sqrt(" + str(d) + ")\n"
                outfile.write(output)

    outfile.close()


def find_n_is_not_Carmichael_but_nOK_is(gen_range, bound, condition) :
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

    # write meta stuff in the outfile
    outfile = open("Results_find_n_is_not_Carmichael_but_nOK_is.txt", "w")
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
            
            if not int_below_512461_is_carmichael(n) and ideal_verifies_Korselt_criterion(I) : 
                output = "(d, n) = (" + str(d) + ", " + str(n) + ")\n"
                outfile.write(output)

    outfile.close()
