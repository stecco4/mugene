# beginnings of the music project


class Note
	attr_reader :pitch_class
	attr_writer :pitch_class
	attr_reader :octave
	attr_writer :octave
	attr_reader :velocity
	attr_writer :velocity
	
	def midi_number
		return 2**(octave+2) if octave >= 0
	end
end


class PentatonicScale
	
end




test = Note.new
#print "\n#{test.methods.sort.join("\n")}"
