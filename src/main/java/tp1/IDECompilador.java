package tp1;

import javax.swing.JFrame;
import javax.swing.SwingUtilities;
public class IDECompilador  extends JFrame{


    private static final long serialVersionUID = 1L;


	// Constructor para configurar los componentes de la ventana
    public IDECompilador() {
        
        setTitle("IDE prueba");

        setSize(400, 300);

        
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        
        setLocationRelativeTo(null);

        // agregar controles componentes etc
    }

    
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            IDECompilador ventana = new IDECompilador();
            
            ventana.setVisible(true);
        });
    }
}
