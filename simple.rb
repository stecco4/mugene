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

			if r <= s + @matrix[[item_index, i]] and r > s
				return @items[i]
			end

			s += @matrix[[item_index, i]]
		end
	end
end

bottom_notes = PentatonicScale.new(39).scale.map { |x| x + 38 }.sort

notes = bottom_notes + bottom_notes.map { |x| x + 12 } + bottom_notes.map { |x| x + 24 }

pmatrix = ProbabilityMatrix.new(notes)
pmatrix.fill

current = 39
10.times do
	puts current
	current = pmatrix.get_next(current)
end
