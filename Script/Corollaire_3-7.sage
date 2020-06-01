load("Is_Carmichael.sage")

def corollaire(borne_q) :
    """
    For every Carmichael number n below 512461, find all cyclotomic
    fields Q(zeta_q), q < borne_q, where q is prime and gcd(Disc(K), n)=1 
    such that nOK is not Carmichael.
    """

    results_file = open("Results_Corollary_3-7.txt", "w")

    for n in carmichael_numbers :
        for q in prime_range(3, borne_q) :
            K = CyclotomicField(q)
            if gcd(n, q) == 1 :
                nOK = K.ideal(n) 
                if not ideal_verifies_Korselt_criterion(nOK) :
                    output = str(n) + " is not Carmichael in Q(zeta" \
                            + str(q) + ")\n"
                    results_file.write(output)

    results_file.close()
