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
	
end




test = Note.new(60) #A5
scale = PentatonicScale.new(62) # d pentatonic
#print "#{scale}\n"
#print "#{scale.n_notes_higher(test,2)}\n"
#print "#{(test+Note.new(30)) > test}\n"







