import sys, os, re
import wikipedia
os.chdir('/Users/ajstein/Desktop/Real Life/Coding Projects/Astrology/')

def reading_names():
    f = open('clean_names.csv')
    astros = [line[:-1] for line in list(f)][1:]
    f.close()
    return(astros)

def clear_file():
    f = open('firstline.csv', 'w')
    f.close()

def extract_first_lines(list_of_names, number_of_names):
    with open('unicodeless.csv', 'a') as f:
        for i in range(0, number_of_names):
            print(str(i) + ': ' + list_of_names[i])
            try:
                first_sentence = wikipedia.summary(list_of_names[i], sentences = 1)
                first_sentence = str(first_sentence.encode('ascii', 'ignore'))
                print(first_sentence)
                f.write(str(i) + ': ' + first_sentence + '\n')
            except:
                pass

def regex():
    dates = []
    f = open('unicodeless.csv')
    lines = [line[:-1] for line in list(f)]
    f.close()

    for i in range(0, len(lines)):
        num = re.match('\d*', lines[i])
        date = re.search('([A-Z][a-z]+ \d{1,2}, \d{3,4}|\d{1,2} [A-Z][a-z]+ \d{3,4})', lines[i])
        if date != None:
            init_date = re.search('\d{3,4}', lines[i][num.end():date.start()])
            if init_date == None:
                print(num.group(), ':', date.group())
                date = date.group().replace(',', '')
                dates.append(date)
    return(dates)

def writing_dates(dates):
    with open('uni_dates.csv', 'w') as f:
        for i in range(0, len(dates)):
            f.write(dates[i] + '\n')



# writing_dates(regex())











# bottom
