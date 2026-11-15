package tp1;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.border.TitledBorder;
import java.awt.*;
import java.io.*;

public class IDECompilador extends JFrame {

    private static final long serialVersionUID = 1L;
    private JTextArea txtInput;
    private JTextArea txtOutput;

    public IDECompilador() {

        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {
            e.printStackTrace();
        }

        setTitle("IDE Compilador - Grupo 6 (SETSWITCH)");
        setSize(900, 700);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);


        JPanel mainPanel = new JPanel(new BorderLayout(10, 10));
        mainPanel.setBorder(new EmptyBorder(10, 10, 10, 10));
        setContentPane(mainPanel);

        // Barra de Menú
        JMenuBar menuBar = new JMenuBar();
        JMenu menuArchivo = new JMenu("Archivo");
        JMenuItem itemAbrir = new JMenuItem("Abrir archivo...");
        itemAbrir.addActionListener(e -> abrirArchivo());
        menuArchivo.add(itemAbrir);
        menuBar.add(menuArchivo);
        setJMenuBar(menuBar);

        // Area de Entrada (Código)
        txtInput = new JTextArea();
        txtInput.setFont(new Font("Consolas", Font.PLAIN, 16));
        txtInput.setMargin(new Insets(8, 8, 8, 8));

        JPanel inputWrapper = new JPanel(new BorderLayout());
        inputWrapper.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Código Fuente", TitledBorder.LEFT, TitledBorder.TOP));
        inputWrapper.add(new JScrollPane(txtInput), BorderLayout.CENTER);

        // Area de Salida (Consola)
        txtOutput = new JTextArea();
        txtOutput.setFont(new Font("Consolas", Font.PLAIN, 14));
        txtOutput.setMargin(new Insets(8, 8, 8, 8));
        txtOutput.setEditable(false);
        txtOutput.setBackground(new Color(40, 42, 54));
        txtOutput.setForeground(new Color(248, 248, 242));

        JPanel outputWrapper = new JPanel(new BorderLayout());
        outputWrapper.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Consola de Salida", TitledBorder.LEFT, TitledBorder.TOP));
        outputWrapper.add(new JScrollPane(txtOutput), BorderLayout.CENTER);

        // Divisor ajustable
        JSplitPane splitPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT, inputWrapper, outputWrapper);
        splitPane.setDividerLocation(350);
        splitPane.setContinuousLayout(true);

        // Panel Inferior
        JPanel panelBotones = new JPanel(new FlowLayout(FlowLayout.RIGHT));

        JButton btnLimpiar = new JButton("Limpiar");
        btnLimpiar.setFont(new Font("Segoe UI", Font.PLAIN, 14));
        btnLimpiar.addActionListener(e -> {
            txtInput.setText("");
            txtOutput.setText("");
        });

        JButton btnCompilar = new JButton("Compilar");
        btnCompilar.setFont(new Font("Segoe UI", Font.BOLD, 14));
        btnCompilar.addActionListener(e -> compilar());

        panelBotones.add(btnLimpiar);
        panelBotones.add(btnCompilar);

        // Ensamblar ventana
        mainPanel.add(splitPane, BorderLayout.CENTER);
        mainPanel.add(panelBotones, BorderLayout.SOUTH);
    }

    private void abrirArchivo() {
        JFileChooser fileChooser = new JFileChooser();
        if (fileChooser.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
            File file = fileChooser.getSelectedFile();
            try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                txtInput.read(reader, null);
                txtOutput.setText("Archivo cargado con éxito: " + file.getName() + "\n");
            } catch (IOException ex) {
                JOptionPane.showMessageDialog(this, "Error al leer el archivo", "Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void compilar() {
        txtOutput.setText("Iniciando análisis léxico y sintáctico...\n\n");
        String codigo = txtInput.getText();

        if (codigo.trim().isEmpty()) {
            txtOutput.append("No hay código para compilar.\n");
            return;
        }

        try {
            Lexico lexer = new Lexico(new StringReader(codigo));
            AnalizadorSintactico sintactico = new AnalizadorSintactico(lexer);
            // Se comparte la tabla de símbolos entre el léxico y el sintáctico
            sintactico.ts = lexer.ts;
            sintactico.parse();

            // 1. Mostrar las reglas sintácticas reconocidas (que ejecutaron acciones)
            if (!sintactico.reglasReconocidas.isEmpty()) {
                txtOutput.append("--- REGLAS SINTÁCTICAS RECONOCIDAS ---\n");
                for (String regla : sintactico.reglasReconocidas) {
                    txtOutput.append(regla + "\n");
                }
                txtOutput.append("\n");
            }

            // 2. Verificar y mostrar errores léxicos, sintácticos o semánticos
            boolean hayErrores = false;

            if (!lexer.erroresLexicos.isEmpty()) {
                hayErrores = true;
                txtOutput.append("--- ERRORES LÉXICOS ---\n");
                for (String err : lexer.erroresLexicos) {
                    txtOutput.append(err + "\n");
                }
            }

            if (!sintactico.erroresSintacticos.isEmpty()) {
                hayErrores = true;
                txtOutput.append("--- ERRORES SINTÁCTICOS / SEMÁNTICOS ---\n");
                for (String err : sintactico.erroresSintacticos) {
                    txtOutput.append(err + "\n");
                }
            }

            // 3. Exportar la Tabla de Símbolos a ts.txt
            lexer.ts.guardarEnArchivo("ts.txt");

            if (hayErrores) {
                txtOutput.append("\n[!] COMPILACIÓN FINALIZADA CON ERRORES. Revise los mensajes anteriores.\n");
            } else {
                txtOutput.append("[OK] Compilación exitosa. Sintaxis correcta y Tabla de Símbolos generada en 'ts.txt'.\n");
            }

        } catch (Exception ex) {
            txtOutput.append("Error fatal durante la compilación: " + ex.getMessage() + "\n");
            ex.printStackTrace();
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            new IDECompilador().setVisible(true);
        });
    }
}
