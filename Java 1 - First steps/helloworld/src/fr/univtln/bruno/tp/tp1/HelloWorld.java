/**
 * Ce premier programme Java
 * dit "Bonjour"
 */
package fr.univtln.bruno.tp.tp1;

/**
 * @author Emmanuel Bruno
 * 
 */
public class HelloWorld {

	/**
	 * @param args le premier paramètre passé en ligne de commande est un prénom 
	 */
	public static void main(String[] args) {
		if (args.length==1) System.out.println("Bonjour "+args[0]);
		else System.out.println("Usage : PremierProgramme [prenom]");
	}

}
