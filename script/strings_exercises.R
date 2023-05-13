# Strings
## Introduction
### Prerequisites
library(tidyverse)

## String basics
string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'

double_quote <- "\""
single_quote <- '\''

x <- c("\"", "\\")
x
writeLines(x)

x <- "\u00b5"
x

c("one", "two", "three")

### String length
str_length(c("a", "R for data science", NA))

str_c("x", "y")
str_c("x", "y", "z")

str_c("x", "y", sep = ", ")

x <- c("abc", NA)
str_c("|-", x, "-|")
str_c("|-", str_replace_na(x), "-|")

str_c("prefix-", c("a", "b", "c"), "-suffix")

name <- "Hadley"
time_of_day <- "morning"
birthday <- F

str_c(
  "Good ", time_of_day, " ", name,
  if (birthday) " and HAPPY BIRTHDAY",
  "."
  )

str_c(c("x", "y", "z"), collapse = ", ")

### Subsetting strings
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
str_sub(x, -3, -1)

str_sub("a", 1, 5)

str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))

### Locales
str_to_upper(c("i", "ı"))
str_to_upper(c("i", "ı"), locale = "tr")

x <- c("apple", "eggplant", "banana")
str_sort(x, locale = "en")  # English
str_sort(x, locale = "haw") # Hawaiian

### Exercises
#### In code that doesn’t use stringr, you’ll often see paste() and paste0().
#### What’s the difference between the two functions?
#### What stringr function are they equivalent to?
#### How do the functions differ in their handling of NA?

#### In your own words, describe the difference between the sep and collapse
#### arguments to str_c().

#### Use str_length() and str_sub() to extract the middle character from
#### a string. What will you do if the string has an even number of characters?
  
#### What does str_wrap() do? When might you want to use it?

#### What does str_trim() do? What’s the opposite of str_trim()?

#### Write a function that turns (e.g.) a vector c("a", "b", "c") into the
#### string a, b, and c. Think carefully about what it should do if given a
#### vector of length 0, 1, or 2.

## Matching patterns with regular expressions
### Basic matches
x <- c("apple", "banana", "pear")
str_view(x, "an")

str_view(x, ".a.")

dot <- "\\."
writeLines(dot)
str_view(c("abc", "a.c", "bef"), "a\\.c")

x <- "a\\b"
writeLines(x)
str_view(x, "\\\\")

### Exercises
#### Explain why each of these strings don’t match a \: "\", "\\", "\\\".

#### How would you match the sequence "'\?
str_view("\"'\\", "\"'\\\\", match = TRUE)

#### What patterns will the regular expression \..\..\.. match? How would you represent it as a string?
str_view(c(".a.b.c", ".a.b", ".....", ".a.b.c.d"), c("\\..\\..\\.."), match = TRUE)

### Anchors
x <- c("apple", "banana", "pear")
str_view(x, "^a")
str_view(x, "a$")

x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")
str_view(x, "^apple$")

### Exercises
#### How would you match the literal string "$^$"?
str_view(c("$^$", "ab$^$sfas"), "\\$\\^\\$", match = TRUE)
str_view(c("$^$", "ab$^$sfas"), "^\\$\\^\\$$", match = TRUE)

#### Given the corpus of common words in stringr::words, create regular expressions that find all words that:
#### Start with “y”.
str_view(stringr::words, "^y", match = T)
#### End with “x”
str_view(stringr::words, "x$", match = T)
#### Are exactly three letters long. (Don’t cheat by using str_length()!)
str_view(stringr::words, "^...$", match = T)
#### Have seven letters or more.
str_view(stringr::words, ".......", match = T)
#### Since this list is long, you might want to use the match argument to str_view() to show only the matching or non-matching words.

### Character classes and alternatives
str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")
str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")
str_view(c("abc", "a.c", "a*c", "a c"), "a[ ]")

str_view(c("grey", "gray"), "gr(e|a)y")

### Exercises
#### Create regular expressions to find all words that:
#### Start with a vowel.
str_view(stringr::words, "^(a|e|i|o|u)")
#### That only contain consonants. (Hint: thinking about matching “not”-vowels.)
str_view(stringr::words, "(a|e|i|o|u)", match=F)
#### End with ed, but not with eed.
str_view(stringr::words, "(^|[^e])ed$", match=T)
#### End with ing or ise.
str_view(stringr::words, "(ing|ise)$", match=T)
#### Empirically verify the rule “i before e except after c”.
str_view(stringr::words, "(cei|[^c]ie)")
str_view(stringr::words, "(cie|[^c]ei)")
#### Is “q” always followed by a “u”?
str_view(stringr::words, "q[^u]", match = TRUE)  
#### Write a regular expression that matches a word if it’s probably written in British English, not American English.

#### Create a regular expression that will match telephone numbers as commonly written in your country.

### Repetition
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
str_view(x, "CC+")
str_view(x, 'C[LX]+')

str_view(x, "C{2}")
str_view(x, "C{2,}")
str_view(x, "C{2,3}")

str_view(x, 'C{2,3}?')
str_view(x, 'C[LX]+?')

### Exercises
#### Describe the equivalents of ?, +, * in {m,n} form.
str_view(x, "CC{0,1}")
str_view(x, "CC{1,}")
str_view(x, "C[LX]{1,}")
str_view(x, "C[LX]{0,}")

#### Describe in words what these regular expressions match: (read carefully to see if I’m using a regular expression or a string that defines a regular expression.)
#### ^.*$
#### "\\{.+\\}"
#### \d{4}-\d{2}-\d{2}
#### "\\\\{4}"

#### Create regular expressions to find all words that:
#### Start with three consonants.
str_view(stringr::words, "^[^aeiou]{3}", match =T)
#### Have three or more vowels in a row.
str_view(stringr::words, "[aeiou]{3,}", match =T)
#### Have two or more vowel-consonant pairs in a row.
str_view(stringr::words, "([aeiou][^aeiou]){2,}", match = T)
#### Solve the beginner regexp crosswords at https://regexcrossword.com/challenges/beginner.

### Grouping and backreferences
str_view(fruit, "(..)\\1", match = TRUE)

### Exercises
#### Describe, in words, what these expressions will match:
#### (.)\1\1
#### "(.)(.)\\2\\1"
#### (..)\1
#### "(.).\\1.\\1"
#### "(.)(.)(.).*\\3\\2\\1"

#### Construct regular expressions to match words that:
#### Start and end with the same character.
str_view(stringr::words, "^(.)((.*\\1$)|\\1?$)")
#### Contain a repeated pair of letters (e.g. “church” contains “ch” repeated twice.)
str_view(stringr::words, "([A-Za-z][A-Za-z]).*\\1")
#### Contain one letter repeated in at least three places (e.g. “eleven” contains three “e”s.)
str_view(stringr::words, "([a-z]).*\\1.*\\1")

## Tools
### Detect matches
x <- c("apple", "banana", "pear")
str_detect(x, "e")

sum(str_detect(words, "^t"))
mean(str_detect(words, "[aeiou]$"))

no_vowels_1 <- !str_detect(words, "[aeiou]")
no_vowels_2 <- str_detect(words, "^[^aeiou]+$")
identical(no_vowels_1, no_vowels_2)

words[str_detect(words, "x$")]
str_subset(words, "x$")

df <- tibble(
  word = words, 
  i = seq_along(word)
)
df %>% 
  filter(str_detect(word, "x$"))

x <- c("apple", "banana", "pear")
str_count(x, "a")
mean(str_count(words, "[aeiou]"))  

df %>% 
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
    )

str_count("abababa", "aba")
str_view_all("abababa", "aba")

### Exercises
#### For each of the following challenges, try solving it by using both a single regular expression, and a combination of multiple str_detect() calls.
#### Find all words that start or end with x.
#### Find all words that start with a vowel and end with a consonant.
#### Are there any words that contain at least one of each different vowel?
  
#### What word has the highest number of vowels? What word has the highest proportion of vowels? (Hint: what is the denominator?)

### Extract matches
length(sentences)
head(sentences)

colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match <- str_c(colours, collapse = "|")
colour_match

has_colour <- str_subset(sentences, colour_match)
matches <- str_extract(has_colour, colour_match)
head(matches)

more <- sentences[str_count(sentences, colour_match) > 1]
str_view_all(more, colour_match)

str_extract(more, colour_match)

str_extract_all(more, colour_match)

str_extract_all(more, colour_match, simplify = TRUE)
x <- c("a", "a b", "a b c")
str_extract_all(x, "[a-z]", simplify = TRUE)

### Exercises
#### In the previous example, you might have noticed that the regular expression matched “flickered”, which is not a colour. Modify the regex to fix the problem.

#### From the Harvard sentences data, extract:
#### The first word from each sentence.
#### All words ending in ing.
#### All plurals.

### Grouped matches
noun <- "(a|the) ([^ ]+)"

has_noun <- sentences %>%
  str_subset(noun) %>%
  head(10)
has_noun %>% 
  str_extract(noun)

has_noun %>% 
  str_match(noun)

tibble(sentence = sentences) %>% 
  tidyr::extract(
    sentence, c("article", "noun"), "(a|the) ([^ ]+)", 
    remove = FALSE
  )

### Exercises
#### Find all words that come after a “number” like “one”, “two”, “three” etc. Pull out both the number and the word.

#### Find all contractions. Separate out the pieces before and after the apostrophe.

### Replacing matches
x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
str_replace_all(x, "[aeiou]", "-")

x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))

sentences %>% 
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>% 
  head(5)

### Exercises
#### Replace all forward slashes in a string with backslashes.

#### Implement a simple version of str_to_lower() using replace_all().

#### Switch the first and last letters in words. Which of those strings are still words?

### Spliting
sentences %>%
  head(5) %>% 
  str_split(" ")

"a|b|c|d" %>% 
  str_split("\\|") %>% 
  .[[1]]

sentences %>%
  head(5) %>% 
  str_split(" ", simplify = TRUE)

fields <- c("Name: Hadley", "Country: NZ", "Age: 35")
fields %>% str_split(": ", n = 2, simplify = TRUE)

x <- "This is a sentence.  This is another sentence."
str_view_all(x, boundary("word"))

str_split(x, " ")[[1]]
str_split(x, boundary("word"))[[1]]

### Exercises
#### Split up a string like "apples, pears, and bananas" into individual components.

#### Why is it better to split up by boundary("word") than " "?
  
#### What does splitting with an empty string ("") do? Experiment, and then read the documentation.

### Find matchings

## Other types of pattern
str_view(fruit, "nana")
str_view(fruit, regex("nana"))

bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = TRUE))

x <- "Line 1\nLine 2\nLine 3"
str_extract_all(x, "^Line")[[1]]
str_extract_all(x, regex("^Line", multiline = TRUE))[[1]]

phone <- regex("
  \\(?     # optional opening parens
  (\\d{3}) # area code
  [) -]?   # optional closing parens, space, or dash
  (\\d{3}) # another three numbers
  [ -]?    # optional space or dash
  (\\d{3}) # three more numbers
  ", comments = TRUE)

str_match("514-791-8141", phone)

microbenchmark::microbenchmark(
  fixed = str_detect(sentences, fixed("the")),
  regex = str_detect(sentences, "the"),
  times = 20
)

a1 <- "\u00e1"
a2 <- "a\u0301"
c(a1, a2)
a1 == a2

str_detect(a1, fixed(a2))
str_detect(a1, coll(a2))

i <- c("I", "İ", "i", "ı")
i
str_subset(i, coll("i", ignore_case = TRUE))
str_subset(i, coll("i", ignore_case = TRUE, locale = "tr"))

stringi::stri_locale_info()

x <- "This is a sentence."
str_view_all(x, boundary("word"))
str_extract_all(x, boundary("word"))

### Exercises
#### How would you find all strings containing \ with regex() vs. with fixed()?
  
#### What are the five most common words in sentences?

## Other uses of regular expressions
apropos("replace")

head(dir(pattern = "\\.Rmd$"))

## stringi
### Exercises
#### Find the stringi functions that:
#### Count the number of words.
#### Find duplicated strings.
#### Generate random text.

#### How do you control the language that stri_sort() uses for sorting?