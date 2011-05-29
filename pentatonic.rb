# beginnings of the music project

# used for to_s methods - $note_names[pitch_class] #=> corresponding note name
$note_names = ["C","C#","D","Eb","E","F","F#","G","Ab","A","Bb","B"]

# used to represent notes
# more data members will be added as they become necessary
# should (hopefully) be immutable
class Note
	
	def initialize(pitch_class, octave)
		@pitch_class = pitch_class
		@octave = octave
		@midi_number = 12*(@octave+1) + @pitch_class if octave >= 0
	end
	
	def initialize(midi_number)
		@pitch_class = midi_number%12
		@octave = midi_number/12 - 1
		@midi_number = midi_number
	end

	attr_reader :pitch_class, :octave, :velocity, :midi_number
	
	# override methods
	def to_s
		return "#{$note_names[@pitch_class]}#{@octave} (#{midi_number})"
	end
	
	def +(a_note_or_a_number)
		if a_note_or_a_number.is_a?(Fixnum)
			return Note.new(@midi_number + a_note_or_a_number)
		elsif a_note_or_a_number.is_a?(Note)
			return Note.new(@midi_number + a_note_or_a_number.midi_number)
		end
	end
	
	def >(note_or_num)
		if note_or_num.is_a?(Fixnum)
			return @midi_number > note_or_num
		elsif note_or_num.is_a?(Note)
			return @midi_number > note_or_num.midi_number
		end
	end
	
	def <(note_or_num)
		if note_or_num.is_a?(Fixnum)
			return @midi_number < note_or_num
		elsif note_or_num.is_a?(Note)
			return @midi_number < note_or_num.midi_number
		end
	end
	
	def ==(note_or_num)
		if note_or_num.is_a?(Fixnum)
			return @midi_number == note_or_num
		elsif note_or_num.is_a?(Note)
			return @midi_number == note_or_num.midi_number 
		end
	end
	
	def >=(note_or_num)
		if note_or_num.is_a?(Fixnum)
			return @midi_number >= note_or_num
		elsif note_or_num.is_a?(Note)
			return @midi_number >= note_or_num.midi_number
		end
	end
	
	def <=(note_or_num)
		if note_or_num.is_a?(Fixnum)
			return @midi_number <= note_or_num
		elsif note_or_num.is_a?(Note)
			return @midi_number <= note_or_num.midi_number
		end
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
	
	attr_reader :scale
	
	def to_s
		return "[#{scale.join(", ")}]"
	end
	
	# get the pitch n scale degrees higher than the given pitch (n may be negative)
	def n_notes_higher(note, how_many)
		#find where the note falls in the scale
		i = scale.index note.pitch_class
		if i == nil
			print "#{note.midi_number} is not in this scale: #{self}\n"
			return nil
		end
		
		if how_many >=0
			return Note.new(note.midi_number + ( 12 + scale[ (i+how_many) % scale.size ] - scale[i]) % 12 )
		else
			tmp = note.midi_number + scale[ (i+how_many) ] - scale[i]
			while tmp > note.midi_number
				tmp -= 12
			end
			return Note.new(tmp)
		end
		
	end
	
	# get the pitch class of scale degree n (the first pitch of the scale is scale degree one)
	def scaleDegree(degree)
		if degree == 0
			print "there is no scale degree 0\n"
			return nil
		else
			return scale[degree]
		end
	end
	
end


# scale constants that may be passes to scale class
$major_scale = [0,2,4,5,7,9,11]
$Aolean_scale = [0,2,3,5,7,8,10]
$harmonic_minor_scale = [0,2,3,5,7,8,11]

# class to hold any scale that repeates every octave
class Scale 
	
	def initialize(pitch, scale)
	
		if scale.is_a?(Array)
			@scale = scale
		else
			print "the second argument of initalize must be of type Array\n"
			return
		end
		
		if pitch.is_a?(Fixnum)
			tmp = pitch % 12
			
			for i in 0..(scale.size - 1)
				@scale[i] = (@scale[i] + tmp ) % 12
			end
		elsif pitch.is_a?(Note)
			tmp = pitch.pitch_class
			for i in 0..(scale.size - 1) 
				@scale[i] = (@scale[i] + tmp) % 12
			end
		end
	end
	
	attr_reader :scale
	
	def to_s
		return "[#{scale.join(", ")}]"
	end
	
	# get the pitch n scale degrees higher than the given pitch (n may be negative)
	def n_notes_higher(note, how_many)
		#find where the note falls in the scale
		i = scale.index note.pitch_class
		if i == nil
			print "#{note.midi_number} is not in this scale: #{self}\n"
			return nil
		end
		
		if how_many >=0
			return Note.new(note.midi_number + ( 12 + scale[ (i+how_many) % scale.size ] - scale[i]) % 12 )
		else
			tmp = note.midi_number + scale[ (i+how_many) ] - scale[i]
			while tmp > note.midi_number
				tmp -= 12
			end
			return Note.new(tmp)
		end
		
	end
	
	# get the pitch class of scale degree n (the first pitch of the scale is scale degree one)
	def scaleDegree(degree)
		if degree == 0
			print "there is no scale degree 0\n"
			return nil
		elsif degree > 0
			return scale[degree - 1]
		else 
			return scale[degree]
		end
	end

	
end











