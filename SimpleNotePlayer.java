
import javax.sound.midi.*;
import java.util.*;


public class SimpleNotePlayer{

		//**********class variables**********
	   static Receiver rcvr;
		static long timeStamp = -1;
		static ShortMessage myMsg = new ShortMessage();
		static int v = 93; //velocity of note
		static int baseNote = 60;
		static int option = 0, i = 0, channel = 0;
		static int transpositionFactor = 0;
		static int shiftDisplacement = 12;
		static char c = 0;
		static char[] layout = new char[32];
		static ArrayList<Integer> notesPlaying = new ArrayList<Integer>(); 
	
	
	public static void playNote(int midiNoteValue){	
		//check if the note is playing and play the noteplay note
		if( midiNoteValue != -1 && notesPlaying.indexOf(midiNoteValue) == -1){ 
			try{
				myMsg.setMessage(ShortMessage.NOTE_ON, channel, midiNoteValue + transpositionFactor, v);
				
				//add note to arraylist
				notesPlaying.add(midiNoteValue);
				
			} catch(InvalidMidiDataException midi_err){
				System.out.println(midi_err);
				System.exit(0);
			}
		  	rcvr.send(myMsg, timeStamp);
		}
	}
	
	
	public static void stopPlayingNote(int midiNoteValue){
		if( midiNoteValue != -1){ 
			try{
				myMsg.setMessage(ShortMessage.NOTE_OFF, channel, midiNoteValue + transpositionFactor, v);
				
				//remove the note from arraylist
				int index = notesPlaying.indexOf(midiNoteValue);
				if( index > -1 )
					notesPlaying.remove(index);
				
			} catch(InvalidMidiDataException f){
				System.out.println(f);
				System.exit(0);
			}
		  	rcvr.send(myMsg, timeStamp);
		}	
	}

		
	public static void main(String[] args) throws InvalidMidiDataException, MidiUnavailableException{	
	
		Scanner scn = new Scanner(System.in);
		//TO_DO make args affect playback speed
		
		rcvr = MidiSystem.getReceiver();
		
		int temp;
		while( scn.hasNextInt() ){
			temp = scn.nextInt();
			playNote(temp);
	 		try{Thread.sleep(800);}catch(Exception e){;};
			stopPlayingNote(temp);
		}
	

		
		
		//wait at the end
		try{Thread.sleep(500);}catch(Exception e){;};
	}
	
}


