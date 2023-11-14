#!/bin/bash

# Fonction pour ajouter un utilisateur
add_user() {
    read -p "Nom d'utilisateur: " username
    if [ -z "$username" ]; then
        echo "Erreur: Nom d'utilisateur vide"
        return 1
    fi

    read -p "Date d'expiration (YYYY-MM-DD): " expiration_date
    if [ -z "$expiration_date" ]; then
        echo "Erreur: Date d'expiration vide"
        return 4
    fi

    if date -d "$expiration_date" >/dev/null 2>&1; then
        if [ "$(date -d "$expiration_date" +%s)" -lt "$(date +%s)" ]; then
            echo "Erreur: La date d'expiration est antérieure à aujourd'hui"
            return 5
        fi
    else
        echo "Erreur: Date d'expiration invalide (format: YYYY-MM-DD)"
        return 6
    fi

    read -s -p "Mot de passe: " password
    echo

    read -p "Identifiant (UID): " uid

    # Ajouter l'utilisateur avec les informations fournies
    if sudo useradd -e "$expiration_date" -p "$(openssl passwd -6 $password)" -u "$uid" "$username"; then
        echo "Utilisateur $username ajouté avec succès"
    else
        echo "Erreur: Impossible d'ajouter l'utilisateur. Vérifiez vos droits d'administration."
    fi
}

# Fonction pour modifier un utilisateur
modify_user() {
    read -p "Nom d'utilisateur à modifier: " username
    if [ -z "$username" ]; then
        echo "Erreur: Nom d'utilisateur vide"
        return 1
    fi

    # Vérifier si l'utilisateur existe
    if id "$username" &>/dev/null; then
        read -p "Nouveau nom d'utilisateur: " new_username
        read -p "Nouvelle date d'expiration (YYYY-MM-DD): " new_expiration_date
        read -s -p "Nouveau mot de passe: " new_password
        echo
        read -p "Nouvel identifiant (UID): " new_uid

        # Modifier les informations de l'utilisateur
        if sudo usermod -l "$new_username" -e "$new_expiration_date" -p "$(openssl passwd -6 $new_password)" -u "$new_uid" "$username"; then
            echo "Utilisateur $username modifié avec succès"
        else
            echo "Erreur: Impossible de modifier l'utilisateur. Vérifiez vos droits d'administration."
        fi
    else
        echo "Erreur: L'utilisateur $username n'existe pas"
        return 2
    fi
}

# Fonction pour supprimer un utilisateur
delete_user() {
    read -p "Nom d'utilisateur à supprimer: " username
    if [ -z "$username" ]; then
        echo "Erreur: Nom d'utilisateur vide"
        return 1
    fi

    # Vérifier si l'utilisateur existe
    if id "$username" &>/dev/null; then
        read -p "Supprimer le dossier utilisateur? (oui/non): " delete_home
        if [ "$delete_home" == "oui" ]; then
            if sudo userdel -r "$username"; then
                echo "Utilisateur $username supprimé avec succès"
            else
                echo "Erreur: Impossible de supprimer l'utilisateur. Vérifiez vos droits d'administration."
            fi
        else
            if sudo userdel "$username"; then
                echo "Utilisateur $username supprimé avec succès"
            else
                echo "Erreur: Impossible de supprimer l'utilisateur. Vérifiez vos droits d'administration."
            fi
        fi
    else
        echo "Erreur: L'utilisateur $username n'existe pas"
        return 2
    fi
}

# Fonction pour gérer les droits sudoers
manage_sudo() {
    read -p "Nom d'utilisateur à ajouter/supprimer des sudoers: " username
    if [ -z "$username" ]; then
        echo "Erreur: Nom d'utilisateur vide"
        return 1
    fi

    if id "$username" &>/dev/null; then
        read -p "Ajouter ou supprimer des droits sudo (ajouter/supprimer/annuler)? " action

        if [ "$action" == "ajouter" ]; then
            if sudo usermod -aG sudo "$username"; then
                echo "Droits sudo accordés à l'utilisateur $username"
            else
                echo "Erreur: Impossible d'ajouter les droits sudo à l'utilisateur. Vérifiez vos droits d'administration."
            fi
        elif [ "$action" == "supprimer" ]; then
            if sudo deluser "$username" sudo; then
                echo "Droits sudo retirés de l'utilisateur $username"
            else
                echo "Erreur: Impossible de supprimer les droits sudo de l'utilisateur. Vérifiez vos droits d'administration."
            fi
        elif [ "$action" == "annuler" ]; then
            echo "Opération annulée"
        else
            echo "Erreur: Action non reconnue"
            return 2
        fi
    else
        echo "Erreur: L'utilisateur $username n'existe pas"
        return 3
    fi
}

# Fonction pour le menu principal
main_menu() {
    while true; do
        echo "Menu Principal"
        echo "1. Ajouter un utilisateur"
        echo "2. Modifier un utilisateur"
        echo "3. Supprimer un utilisateur"
        echo "4. Gérer les droits sudoers"
        echo "5. Quitter"
        read -p "Choisissez une option: " choice

        case $choice in
            1) add_user ;;
            2) modify_user ;;
            3) delete_user ;;
            4) manage_sudo ;;
            5) exit 0 ;;
            *) echo "Option invalide";;
        esac
    done
}

# Menu principal
main_menu
