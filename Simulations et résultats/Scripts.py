# Antoine Hugounet
# Scripts.py
# https://www.newbedev.com/python/howto/how-to-iterate-over-files-in-a-given-directory/

"""
Après avoir effectué plein de simulations numériques pour regarder 
si des entiers de Carmichael sont de Carmichael dans tel ou tel corps 
quadratique ou cyclotomique, on se rend compte qu'ils sont majoritairement
pas de Carmichael. Ce script extrait des fichiers résultats les nombres
qui sont de Carmichael dans un certain type de corps.

Par exemple
find_Carmichael_in_Results_files("cyclotomic")
écrit dans un fichiers les couples (n, q) tels que n est 
de Carmichael dans Q(zetaq)
"""

import os

# https://stackoverflow.com/questions/5137497/find-current-directory-and-files-directory
# current working directory
cwd = os.getcwd()

def find_Carmichael_in_Results_files(field_type) :
    
    outfile = open("Find_Carmichael_in_Results_files_" + field_type + ".txt", "w")

    for filename in os.listdir(cwd) :
        if field_type in filename :
            f = open(filename,"r")
            for line in f :
                if "True" in line :
                    outfile.write(line)

            f.close()

    outfile.close()

def proportion_carmichael(field_type) :

    outfile = open("Proportion_Carmichael_" + field_type + "_results.txt", "w")
    number_of_tests = 0
    number_of_True = 0

    for filename in os.listdir(cwd) :
        if field_type in filename and "Find" not in filename :
            f = open(filename, "r")
            for line in f :
                number_of_tests += 1
                if "True" in line :
                    number_of_True += 1

            f.close()

    proportion = number_of_True / number_of_tests

    outfile.write("Field type: " + field_type + "\n")
    outfile.write("Number of tests: " + str(number_of_tests) + "\n")
    outfile.write("Number of Carmichael ideals: " + str(number_of_True) + "\n")
    outfile.write("Proportion of Carmichael ideals: " + str(proportion) + "\n")
    outfile.close()
