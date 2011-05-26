require "pentatonic.rb"

class ProbabilityMatrix
	def initialize(items)
		@items = items
		@matrix = Hash.new

		@items.length.times do |i|
			@items.length.times do |k|
				@matrix[[i, k]] = 0
			end
		end

		fill

		self
	end

	# Fills the matrix with probability values
	def fill
		# Go through each item
		@items.length.times do |i|
			@items.length.times do |offset|
				left = i - offset
				right = i + offset

				# The equation is the following:
				# value of 46 given to the item staying on the current item
				# As you move right and left item, the value is given by 50 - (distance from center note + 2)^2
				val = 50 - ((offset + 1) ** 2)
				val = 0 if val < 0

				if left >= 0
					@matrix[[i, left]] = val
				end

				if right < @items.length
					@matrix[[i, right]] = val
				end
			end
		end
	end

	def display
		print "\t"
		@items.each do |item|
			print item.to_s + "\t"
		end

		puts

		@items.length.times do |i|
			print @items[i].to_s + "\t"

			@items.length.times do |k|
				print @matrix[[i, k]].to_s + "\t"
			end

			puts
		end
	end

	def get_next(item)
		item_index = @items.index(item)	

		sum = 0
		@items.length.times do |i|
			sum += @matrix[[item_index, i]]
		end

		r = rand(sum)

		s = 0
		@items.length.times do |i|
			next if @matrix[[item_index, i]] == 0

			if r < s + @matrix[[item_index, i]] and r >= s
				puts @items[i]
				return @items[i]
			end

			s += @matrix[[item_index, i]]
		end

		puts "here"
		puts r
		puts item
		#return @items[@items.length - 1]
	end

	def set_row(item, value)
		item_index = @items.index(item)
		@items.length.times do |i|
			@matrix[[item_index, i]] = value
		end
	end

	def set_column(item, value)
		item_index = @items.index(item)
		@items.length.times do |i|
			@matrix[[i, item_index]] = value
		end
	end
end

class Rhythm
	WHOLE_NOTE = 12
	HALF_NOTE = 6
	QUARTER_NOTE = 2
	EIGHTH_NOTE = 1

	def self.as_array
		[WHOLE_NOTE, HALF_NOTE, QUARTER_NOTE, EIGHTH_NOTE]
	end
end

bottom_notes = PentatonicScale.new(39).scale.map { |x| x + 38 }.sort

notes = bottom_notes + bottom_notes.map { |x| x + 12 } + bottom_notes.map { |x| x + 24 }

note_matrix = ProbabilityMatrix.new(notes)

rhythm_matrix = ProbabilityMatrix.new(Rhythm::as_array())
rhythm_matrix.set_column(Rhythm::WHOLE_NOTE, 0)

current_note = 39
current_rhythm = Rhythm::QUARTER_NOTE
10.times do
	puts current_note
	puts current_rhythm
	current_note = note_matrix.get_next(current_note)
	current_rhythm = rhythm_matrix.get_next(current_rhythm)
end
