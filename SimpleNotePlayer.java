
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
		int tempo = 120;
		int i;
		
		//look for -t command-line argument to change the tempo
		if(args != null && args.length > 0){
			i = Arrays.binarySearch(args, "-t");
			if( i >= 0 ){
				if(i <= args.length - 2){
					tempo = Integer.parseInt(args[i+1]);
				}
				else{
					System.err.println("No arguement was given after -t\n");
				}
			}
		}
		
		
		rcvr = MidiSystem.getReceiver();
		
		int temp; int duration;
		
		while( scn.hasNextInt() ){
			temp = scn.nextInt();
			duration = scn.nextInt();
			playNote(temp);
			
			// 3000 is pause for a minute / quarter note duration
	 		try{Thread.sleep( (30000/tempo)*duration );}catch(Exception e){;}; 
			
			stopPlayingNote(temp);
		}
	

		
		
		//wait at the end
		try{Thread.sleep(500);}catch(Exception e){;};
	}
	
}


