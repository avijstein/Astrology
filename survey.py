import sys, os, re
import wikipedia
os.chdir('/Users/ajstein/Desktop/Real Life/Coding Projects/Astrology/')

loa = open('clean_names.csv')
astros = [line[:-1] for line in list(loa)][1:]
print(astros)

def clear_file():
    f = open('firstline.csv', 'w')
    f.close()

def extract_first_lines(list_of_names, number_of_names):
    with open('firstline.csv', 'a') as f:
        for i in range(0, number_of_names):
            print(str(i) + ': ' + list_of_names[i])
            try:
                first_sentence = wikipedia.summary(list_of_names[i], sentences = 1)
                print(first_sentence)
                f.write(str(i) + ': ' + first_sentence + '\n')

            except:
                pass


# clear_file()
# extract_first_lines(astros, len(astros))









# bottom
