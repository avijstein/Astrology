import sys, os, re
import wikipedia
os.chdir('/Users/ajstein/Desktop/Real Life/Coding Projects/Astrology/')

def reading_names():
    loa = open('clean_names.csv')
    astros = [line[:-1] for line in list(loa)][1:]
    loa.close()
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

def reading_sums():
    f = open('firstline.csv')
    summaries = [line[:-1] for line in list(f)]
    f.close()
    return(summaries)


def regex():
    dates = []
    lines = reading_sums()

    for i in range(0, len(lines)):
        num = re.match('\d*', lines[i]).group()
        date1 = re.search('\d{1,2} [A-Z][a-z]+ \d{4}', lines[i])
        date2 = re.search('\w+ \d{1,2}, \d{4}', lines[i])
        if date1 != None:
            date1 = date1.group()
            print(num, ":", date1)
            dates.append(date1)
        if date2 != None:
            date2 = date2.group()
            date2 = date2.replace(',', '')
            print(num, ":", date2)
            dates.append(date2)
    return(dates)


def writing_dates(dates):
    with open('dates.csv', 'w') as f:
        for i in range(0, len(dates)):
            f.write(dates[i] + '\n')



# writing_dates(regex())











# bottom
