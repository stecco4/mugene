# beginnings of the music project


class Note
	
	def initialize(pitch_class, octave)
		@pitch_class = pitch_class
		@octave = octave
	end
	
	def initialize(midi_number)
		@pitch_class = midi_number%12
		@octave = midi_number/12 - 1
	end

	attr_accessor :pitch_class, :octave, :velocity
	
	def midi_number
		return 12*(octave+1) + pitch_class if octave >= 0
	end
	
end


class PentatonicScale
	
	# holds the ordered pitch set of a minor pentatonic scale based on
	# the starting pitch class or a midi number, or a Note object
	def initialize(pitch)
		if pitch.is_a?(Fixnum)
			@scale = [pitch%12, (pitch+3)%12, (pitch+5)%12, (pitch+7)%12, (pitch+10)%12]
		elsif pitch.is_a?(Note)
			tmp = pitch.pitch_class
			@scale = [tmp%12, (tmp+3)%12, (tmp+5)%12, (tmp+7)%12, (tmp+10)%12]
		end
	end
	
	attr_accessor :scale
	
	def to_s
		return "[#{scale.join(", ")}]"
	end
	
end




test = Note.new(56) #A-flat 3
scale = PentatonicScale.new(62) # d pentatonic
scale2 = PentatonicScale.new(test) # g pentatonic



#print "\n#{test.methods.sort.join("\n")}"

print "#{scale}\n"
print "#{scale2}\n"

