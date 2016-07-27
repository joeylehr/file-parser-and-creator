class String
    def is_i?
       /\A[-+]?\d+\z/ === self
    end
end

# MAYBE LOOP THROUGH DIRECTORY AND ASSIGN BASED 
# ON IF FILE CONTAINS A COMMA, SPACE, OR PIPE BELOW METHODS/PARSES


def comma_file_parser
  @comma_names = File.open("text_files/comma.txt").readlines.each do |line|
    if line.include?("\n") # removes '\n' (line breaker)
      line.gsub!(/\n/, '')
    else
      line
    end
  end
end
# returns:
# ["Abercrombie, Neil, Male, Tan, 2/13/1943", ...] 
# ==> column order: last name, first name, gender, favorite color, date of birth

def pipe_file_parser
  @pipe_names = File.open("text_files/pipe.txt").readlines.each do |line|
    if line.include?("\n")
      line.gsub!(/\n/, '')
    else
      line
    end
  end
end
# returns:
# ["Smith | Steve | D | M | Red | 3-3-1985", ..."] 
# ==> column order: last name, first name, middle initial, gender, favorite color, date of birth

def space_file_parser
  @space_names = File.open("text_files/space.txt").readlines.each do |line|
    if line.include?("\n")
      line.gsub!(/\n/, '')
    else
      line
    end
  end
end
# returns:
# ["Kournikova Anna F F 6-3-1975 Red", ...] 
# ==> column order: last name, first name, middle initial, gender, favorite color, date of birth

def comma_names
  @comma_names
end

def pipe_names
  @pipe_names
end

def space_names
  @space_names
end


# THERE CAN BE AN ISSUE IF THERE IS A SPACE IN THE FIRST NAME SO I DECIDED TO 
# USE THE NEGATIVE INDEX TO GET MIDDLE INITIAL ELEMENT IN THE SLICE METHOD
# THE METHODS WITHIN THE BLOCK ARE DESTRUCTIVE SO IF YOU CALL SPACE / PIPE + _NAMES 
# IT WILL RETURN THE NEW ARRAY
def remove_initial_and_format_change(info) # removes middle initial for space_names and pipe_names AND puts comma_names into nested arrays
  if !info[0].include?("|") && !info[0].include?(",")
    info.map! {|element| element.split(" ")}
    info.each {|element| element.slice!(-4)}  
    info
  elsif info[0].include?("|")
    info.map! {|element| element.split(" | ")}
    info.each {|element| element.slice!(-4)}  
    info
  else
    info.map! {|element| element.split(", " )} 
  end
end


# Used for pipe_names and comma_names, uses is_i? to see if the last char is an integer / meaning the date
# and if so, will reorder the nested arrays to the correct format
def reorder_info(info) 
  if (info[0][-1][-1]).is_i? == true 
    order = [0, 1, 2, 4, 3]
    info.map! do |element|
      order.map {|x| element[x]}
    end
  else 
    info  
  end
end


# Adds all arrays together
def combine_info
  @combine_info = pipe_names + space_names + comma_names 
end


# Formats  'F' and 'M' into 'Female' and 'Male'
# Formats dates separated with '-' to use '/' 
def gender_and_date_formater
  combine_info.each do |element| 
    if element[2] == "M"
      element[2] = "Male"
    elsif element[2] == "F"
      element[2] = "Female"
    end
    if element[3].include?("-")
      element[3].gsub!(/-/, '/')
    end
  end
end

def array_to_hash
  @final_array = []
  gender_and_date_formater.map do |element|
    final_array << {last_name: element[0], first_name: element[1], gender: element[2], birth_date: element[3], fav_color: element[4]}
  end
  @final_array
end


def final_array
  @final_array
end

# Adds line space to each array
def add_line_breaks(arr)
  arr.map {|element| element[0..-1] + ["\n"]}
end

def sort_by_gender_then_last_name # sorted by gender (females before males) then by last name ascending
  sorted = final_array.sort_by {|k,v| [k[:gender], k[:last_name]] }
  hash_values = sorted.map {|element| element.values}
  with_line_breaks = add_line_breaks(hash_values)
  with_line_breaks.unshift(["Output 1:\n"])
  with_line_breaks.join(", ").gsub(/,/, '').gsub( /\n\s+/, "\n" )
end

def sort_by_birthday_then_last_name # sorted by birth date, ascending then by last name ascending
  sorted = final_array.sort_by {|k,v| [k[:birth_date][-2..-1], k[:last_name]] }
  hash_values = sorted.map {|element| element.values}
  with_line_breaks = add_line_breaks(hash_values)
  with_line_breaks.unshift(["Output 2:\n"])
  with_line_breaks.join(", ").gsub(/,/, '').gsub( /\n\s+/, "\n" )
end

def sort_by_last_name # sorted by last name, descending
  sorted = final_array.sort_by {|k,v| k[:last_name] }
  hash_values = sorted.map {|element| element.values}.reverse
  with_line_breaks = add_line_breaks(hash_values)
  with_line_breaks.unshift(["Output 3:\n"])
  with_line_breaks.join(", ").gsub(/,/, '').gsub( /\n\s+/, "\n" )
end

def final_name_info
  sort_by_gender_then_last_name + "\n" + sort_by_birthday_then_last_name + "\n" + sort_by_last_name
end

def create_goal_file
  File.open('goal.txt', 'w') { |file| file.write("#{final_name_info}") }
end

def run_em_all
  comma_file_parser
  pipe_file_parser
  space_file_parser
  remove_initial_and_format_change(pipe_names)
  remove_initial_and_format_change(comma_names)
  remove_initial_and_format_change(space_names)
  reorder_info(pipe_names) 
  reorder_info(comma_names) 
  reorder_info(space_names)
  combine_info
  gender_and_date_formater
  array_to_hash
  final_name_info
  create_goal_file
end

run_em_all
puts "Please find the new 'goal.txt' within the cyrus_challenge directory that has the parsed information."


# RESOURCES:

# Reordering index of an arry:
# http://stackoverflow.com/questions/7936509/how-do-i-quickly-reorder-a-ruby-array-given-an-order

# Working with I/O files:
# http://ruby.bastardsbook.com/chapters/io/

# Iterate through a file directory:
# http://stackoverflow.com/questions/2512254/iterate-through-every-file-in-one-directory 