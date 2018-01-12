# Astrology of Astronomers

The project intends to analyze the astrological symbols of famous astronomers. The data is primarily being drawn from Wikipedia's [list of astronomers](https://en.wikipedia.org/wiki/List_of_astronomers).

### Methods

**Names:** After copying the list of astronomers into Excel, I used a manual version of regular expressions to grab just the names of the astronomers (this file is `justnames.csv`).

**Wikipedia:** Using the wikipedia package for python, I gathered wikipedia pages with the list of names. I only read in the first sentence of each of the wikipedia articles, since the birthdate, if known, is almost always in the first sentence. For some articles, the sentence ended abruptly, as the wikipedia package thought "Dr." was the complete sentence, rather than "Dr. Astronomer was born on 23 July 1922." However, these occurrences were relatively infrequent and didn't diminish the results significantly.

**Unicode:** A major roadblock was that the first sentence would often contain a unicode character that couldn't be parsed, and the code would throw a `UnicodeEncodingError`. Fortunately, I was able to have it ignore those characters, and improved the capture rate from 20.4% to 94% of articles.

**Regex:** Now with a long list of first sentences (736 of them), I used regular expressions to pull out dates, formatted similar to 23 July 1922 or July 23, 1922. After a bit more experimenting, I didn't find any dates formatted differently. If there were multiple dates in a sentence, such as "July 23, 1922 -- August 21, 1992," the regex pulled the first date, presuming it to be the birthdate.

**Dates:** I imported the list of dates into R, and converted the date strings into Date objects. Using the day of the year, I sorted each date into its respective zodiac symbol category. I aggregated the data, and found the distribution of zodiac signs.




<!-- bottom -->
