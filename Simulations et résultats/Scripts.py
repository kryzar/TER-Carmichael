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
            f = open(filename,'r')
            for line in f :
                if "is Carmichael" in line :
                    outfile.write(line)

            f.close()

    outfile.close()
