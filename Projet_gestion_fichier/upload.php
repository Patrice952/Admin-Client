<?php
// Traitement du téléchargement de fichiers
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['file'])) {
    $uploadDir = 'uploads/';
    $uploadedFile = $uploadDir . basename($_FILES['file']['name']);
    
    if (move_uploaded_file($_FILES['file']['tmp_name'], $uploadedFile)) {
        echo "Le fichier a été téléchargé avec succès.";
    } else {
        echo "Une erreur s'est produite lors du téléchargement du fichier.";
    }
}

// Traitement de la suppression de fichiers
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['deleteFile'])) {
    $fileToDelete = $_POST['deleteFile'];

    if (file_exists($fileToDelete)) {
        unlink($fileToDelete);
        echo "Le fichier a été supprimé avec succès.";
    } else {
        echo "Le fichier n'existe pas ou une erreur s'est produite lors de la suppression.";
    }
}
$fileList = glob("uploads/*");

foreach ($fileList as $file) {
    echo "<p><a href='$file' download>" . basename($file) . "</a> ";
    echo "<form method='post' style='display:inline;'>
            <input type='hidden' name='deleteFile' value='$file'>
            <button type='submit'>Supprimer</button>
          </form></p>";
}

// Gestion de la suppression de fichiers
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['deleteFile'])) {
    $fileToDelete = $_POST['deleteFile'];

    if (file_exists($fileToDelete)) {
        unlink($fileToDelete);
        echo "Le fichier a été supprimé avec succès.";
    } else {
        echo "Le fichier n'existe pas ou une erreur s'est produite lors de la suppression.";
    }
}

?>
