
# Processing Russian Troll data from fivethirtyeight.com
require 'csv'

# There are non-UTF8 characters. This seems to make it so that we can read
# all of the files.
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

def count_troll_types(filename)
 # read the text of the whole file
 csv_text = File.read(filename)
 # now parse the file, assuming it has a header row at the top
 csv = CSV.parse(csv_text, :headers => true)

 # These are the header categories
 # You can get more information about each category if you scroll
 # down to the README.md here:
 # https://github.com/fivethirtyeight/russian-troll-tweets
 '''
 external_author_id
 author
 content
 region
 language
 publish_date
 harvested_date
 following
 followers
 updates
 post_type
 account_type
 new_june_2018
 retweet
 account_category
 '''

 # map from categories to the number of tweets in category
 categories = Hash.new
 # go through each row of the csv file
 csv.each do |row|
   # convert the row to a hash
   # the keys of the hash will be the headers from the csv file
   hash = row.to_hash
   # this is a trick to make sure that this key exists in a hash
   # so that the next line which adds 1 will never fail
   if !categories.include? hash['account_category']
     categories[hash['account_category']] = 0
   end
   # This cannot fail because if the key hadn't existed,
   # then the previous if will have created it
   categories[hash['account_category']] += 1
 end
 puts
 # now print the key/value pairs
 categories.each do |key, value|
   puts "#{key} occurs #{value} times"
 end
end

# This checks if the current file is the main file that was run
# so this is sort of like "public static void main" in Java/C#

count_troll_types("tweets_5k.csv")

def most_Words(filename) #this function finds the most popular word in the passed csv

 wordMap = Hash.new # creating a hash to store individual words as key and #of occurances as value
 file = File.open(filename)
 csv = CSV.parse(file, :headers => true)
 csv.each do |row| #to apply my code to every row
   line = row.to_hash # I make a hash for every row, so that on the next line--
   #-- I can store "content" as the key for every row and the actual content (the string) as its value.
   content = line['content'] # look at this line as value = map['key']
       words = content.split(" ") #split content at every space so I can get an array of all the words in the row
       words.each do |w|
       if w == "" then #discarding empty values in array: words
           next
       elsif wordMap.include?(w) #Notice that wordMap is declared outside of the csv-for-loop--
           #-- this way I can add any new words to the map.
         wordMap[w] = wordMap[w] + 1 # the value increments by 1 if the key exists
       else
         wordMap[w] = 1 # else, make the key equal to 1
       end
     end
    
   end
   puts
   x = wordMap.max_by{|k,v| v}
   print "The most popular word in the text is '#{x[0]}', occuring #{x[1]} times"
   puts
 end
   
most_Words("tweets_5k.csv")

def most_Dates(filename) #this function gives the most popular dates people tweeted on

   dateMap = Hash.new #to add dates as keys and occurances as values
   file = File.open(filename)
   csv = CSV.parse(file, :headers => true)
   csv.each do |row|
       line = row.to_hash # Here, I am repeating the same thing I did in the previous function
       publish_date = line['publish_date'] #Now, with this, I can access the 'publish_date' section
           dates = publish_date.split(" ") #splitting the date at space into an array because--
           #-- I only need the date from 'publish date'. I don't need the time.
           dates.each do |d|
               if d.include?(":") then #deleting the time from the array
                   next
               elsif dateMap.include?(d) #same idea as in the previous function.
                   dateMap[d] = dateMap[d] + 1
               else  
                   dateMap[d] = 1
               end
       end
   end
   puts
   puts "Top ten dates with the most tweets:"
   dateMap.sort_by{|k, v| v}.reverse[0..9].each do |row|
       puts "On #{row[0]}, there were #{row[1]} tweets."
   end
   puts
end

most_Dates("tweets_5k.csv")

def most_Popular_Time(filename) #this function gives you the number of tweets in every military hour.

   timeMap = Hash.new
   file = File.open(filename)
   csv = CSV.parse(file, :headers => true)
   csv.each do |row|
   line = row.to_hash
   public_time = line['publish_date'] #public_time is value
   times = public_time.split(" ") #splitting at space because I donot want the date, only the time.
   times.each do |tim|
       if tim.include?("/") #removing the dates from the array as we only need the time.
           times.delete(tim)
       end
   end
       times.each do |t|
           tt = t.slice(0..t.index(":")-1).to_i # to delete everything after the colon in time
           if timeMap.include?(tt)
               timeMap[tt] = timeMap[tt] + 1 # 't' here is the key, value = value + 1
           else
               timeMap[tt] = 1 # value = 1
           end
       end
   end

   timeMap.sort_by{|k, v| k}.each do |dates|
   puts "There were a total of #{dates[1]} tweets at hour #{dates[0]}."
   end
puts
end

most_Popular_Time("tweets_5k.csv")

def most_Popular(filename) #this function gives the most followed user

   followMap = Hash.new
   file = File.open(filename)
   csv = CSV.parse(file, :headers => true)
   csv.each do |row|
       line = row.to_hash
       followerNum = line['followers'].to_i
       author = line['author']
       if followMap.include?(author) && followerNum > followMap[author]
           followMap[author] = followerNum
       elsif  not followMap.include?(author)
           followMap[author] = followerNum
       end
   end
   puts
   most_pop = followMap.sort_by{|k, v| v}.reverse[0]
   puts "The most popular user is '#{most_pop[0]}' with #{most_pop[1]} followers"
   puts
end

most_Popular('tweets_5k.csv')

def most_Words_Account(filename) #the top ten words used by every account_type
   wordMap2 = Hash.new
   file = File.open(filename)
   csv = CSV.parse(file, :headers => true)
   csv.each do |row|
       line = row.to_hash
       account_category = line['account_type']
       if not wordMap2.include?(account_category)
           wordMap2[account_category] = Hash.new      
       end
       content = line['content']
       words = content.split(" ")
       words.each do |word|
           if word == "" then
               next
           elsif wordMap2[account_category].include?(word)
               wordMap2[account_category][word] = wordMap2[account_category][word] + 1
           else
               wordMap2[account_category][word] =  1
           end
       end
   end
   wordMap2.keys.each do |type|
       wordMap2[type].sort_by{|k, v| v}.reverse[0..9].each do |row|
       puts "The word that occurs the most in a tweet by a(n) #{type} account type in the entire text file is '#{row.join("' -- appearing ")} times."
       end
   (1..120).each{ |n| print("-")}
   puts
   end
end

most_Words_Account("tweets_5k.csv")

def most_Words_Author(filename) #This function gives the word that the author uses the most
   wordMap3 = Hash.new
   file = File.open(filename)
   csv = CSV.parse(file, :headers => true)
   csv.each do |row|
       line = row.to_hash
       author = line['author']
       if not wordMap3.include?(author)
           wordMap3[author] = Hash.new      
       end
       content = line['content']
       words = content.split(" ")
       words.each do |word|
           if word == "" then
               next
           elsif wordMap3[author].include?(word)
               wordMap3[author][word] = wordMap3[author][word] + 1
           else
               wordMap3[author][word] =  1
           end
       end
   end
   puts
   wordMap3.keys.each do |type|
       wordMap3[type].sort_by{|k, v| v}.reverse[0..0].each do |row|
       puts "The most popular word by '#{type}' in the entire text file is '#{row.join("' -- appearing ")} times."
       end
end
puts
end

most_Words_Author("tweets_5k.csv")

def author_fav_time(filename)
   favAuDate = Hash.new
   file = File.open(filename)
   csv = CSV.parse(file, :headers => true)
   csv.each do |row|
       line = row.to_hash
       author = line['author']
       public_time = line['publish_date']
       if not favAuDate.include?(author)
           favAuDate[author] = Hash.new
       end
       times = public_time.split(" ")
       times.each do |t|
           if t.include?("/")
               times.delete(t)
           end
       end
           times.each do |t|
               tt = t.slice(0..t.index(":")-1).to_i
               if favAuDate[author].include?(tt)
                   favAuDate[author][tt] = favAuDate[author][tt] + 1
               else
                   favAuDate[author][tt] = 1
               end
           end
       end
       favAuDate.keys.each do |type|
           favAuDate[type].sort_by{|k, v| v}.reverse[0..0].each do |row|
           puts "'#{type}'s most favorite hour to tweet is hour '#{row.join("' -- where he has tweeted ")} times."
           end
       end
end

author_fav_time("tweets_5k.csv")

def sesquipedalian_troller(filename)
  
   # This function gives the most sesquipedalin troller in the entire text.
   # However, I have limited the words to less than 15 chars as words more than 15 chars are sometimes just gibberish.
   # Also, I have solved the issue of words such as "ComputerScienceIsFun" by splitting them at Capital Letters.
   # This function also filters out 'words' that links to a page.

   wordLengthMap = Hash.new
   file = File.open(filename)
   csv = CSV.parse(file, :headers => true)
   csv.each do |row|
       line = row.to_hash
       author = line['author']
       content = line['content']
       if not wordLengthMap.include?(author)
           wordLengthMap[author] = Hash.new #creating a hash as a value f/r a key in another hash
       end
       #now I want to count the length of every word and store it in the hash inside the hash
       words = content.split(" ")
       betterWords = Array.new
       words.each do |ew|
           betterWords = ew.split(/(?<!\s)(?=[A-Z])/)
       end
       editedWords = Array.new
       i = 0
       betterWords.each do |eww|
           if eww.length>15 || eww.length == 0
               betterWords.delete(eww)
           else 
               editedWords[i] = eww.delete("^a-zA-Z") # I want to delete any 'word' that doesn't have only letters. This line stores the good words into new array.
               i += 1
           end
       end
       editedWords.each do |w|
           if not wordLengthMap[author].include?(w)
               wordLengthMap[author][w] = w.length
           end
       end
   end
   puts
   longest_word = ""
   longest_word_user = ""
   wordLengthMap.keys.each do |type|
       row = wordLengthMap[type].sort_by{|k, v| v}.reverse[0]
       if row[0].length > longest_word.length then
           longest_word = row[0]
           longest_word_user = type
       end
   end
   puts "The most sesquipedalian troller is '#{longest_word_user}' who uses '#{longest_word}' which has #{longest_word.size} characters."
   puts
end

sesquipedalian_troller("tweets_5k.csv")