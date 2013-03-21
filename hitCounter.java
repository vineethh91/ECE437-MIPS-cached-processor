import java.io.*;
import java.util.*;

public class hitCounter {

    public static void main(String args[]) throws IOException {
        System.out.println(args.length);


        BufferedReader reader = new BufferedReader(new FileReader(new File(args[0])));
        BufferedWriter writer = new BufferedWriter(new FileWriter(new File(args[1])));

        String line = null;
        String instruction = null;
	int nextLineIsInstruction = 0;
        int hitCount = 0;
        while ((line=reader.readLine()) != null) {
            
            if(nextLineIsInstruction == 1) {
                instruction = line;
		nextLineIsInstruction = 0;
            }
            if(line.contains("D$")) {
                if(line.contains("HIT")) {
                    //System.out.println(line);
                    hitCount++;

                    writer.write("Hit Count => " + Integer.toHexString(hitCount));
                    writer.write("       Instruction => " + instruction.trim());                    
                    writer.write("       ");
                    writer.write(line.trim());
                    writer.newLine(); 
                }
            }
            if(line.contains("I$")) {
                nextLineIsInstruction = 1;
            }
        }

        reader.close();
        writer.close();
    }
} 
