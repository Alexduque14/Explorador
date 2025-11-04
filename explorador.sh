#!/bin/bash

# Explorador de Arquivos com dialog
# Autor: Álex Alvarez Duque

while true; do
    opcao=$(dialog --title "Explorador de Arquivos - ECOS11A" \
        --menu "Escolha uma opção:" 20 60 10 \
        1 "Criar diretório" \
        2 "Criar arquivo" \
        3 "Mudar permissões de arquivo/diretório" \
        4 "Mover arquivo" \
        5 "Preencher arquivo" \
        6 "Exibr data/hora do sistema" \
        7 "Alterar data/hora do sistema" \
        8 "Sair" \
        3>&1 >&2 2>&3)

    [ $? -ne 0 ] && clear && break # Sai se o usuário apertar ESC

    case $opcao in
        1)
            dir=$(dialog --inputbox "Digite o nome do diretório:" 10 50 3>&1 1>&2 2>&3)

            if [ -d "$dir" ]; then 
                dialog --msgbox "Diretório '$dir' ja existente!" 6 40
            else
                mkdir -p "$dir" && dialog --msgbox "Diretório '$dir' criado!" 6 40
            fi
            ;;

        2)
            arq=$(dialog --inputbox "Digite o nome do arquivo:" 10 50 3>&1 1>&2 2>&3)

            if [ -f "$arq" ]; then  
                dialog --msgbox "Arquivo '$arq' já existente!" 6 40
            else
                touch "$arq" && dialog --msgbox "Arquivo '$arq' criado!" 6 40
            fi
            ;;

        3)
            alvo=$(dialog --inputbox "Informe o arquivo/diretório para mudar permissões:" 10 50 3>&1 1>&2 2>&3)
            [ $? -ne 0 ] && continue

            if [ -f "$alvo" ]; then

                modo=$(dialog --menu "Escolha o tipo de permissão:" 15 50 5 \
                    1 "Somente leitura (444)" \
                    2 "Execução (755)" \
                    3 "Personalizável" \
                    3>&1 1>&2 2>&3)
                    [ $? -ne 0 ] && continue
                case $modo in
                    1) chmod 444 "$alvo" ;;
                    2) chmod 755 "$alvo" ;;

                    3) perms=$(dialog --inputbox "Digite o modo (ex: 700, 644):" 10 50 3>&1 1>&2 2>&3)
                    chmod "$perms" "$alvo" ;;
                esac
                dialog --msgbox "Permissões alteradas!" 6 40
            else 
                dialog --msgbox "Arquivo/diretorio '$alvo' não existe!" 6 40
            fi
            ;;

        4)
            
            orig=$(dialog --inputbox "Arquivo a mover:" 10 50 3>&1 1>&2 2>&3)

            [ $? -ne 0 ] && continue

            if [ ! -f "$orig" ]; then
                dialog --msgbox "Arquivo '$orig' não existe!" 6 40
                continue
            fi

            dest=$(dialog --inputbox "Destino (diretório):" 10 50 3>&1 1>&2 2>&3)

            [ $? -ne 0 ] && continue

            if [ ! -d "$dest" ]; then
                dialog --msgbox "Diretorio '$dest' não existe!" 6 40
                continue
            fi

            mv "$orig" "$dest" && dialog --msgbox "Arquivo movido com sucesso!" 6 40
            ;;
        5)
            arq=$(dialog --inputbox "Informe o arquivo a preencher:" 10 50 3>&1 1>&2 2>&3)
            [ $? -ne 0 ] && continue
            if [ ! -f "$arq" ]; then
                dialog --msgbox "Arquivo '$arq' não existe!" 6 40
                continue
            fi
            tipo=$(dialog --menu "Escolha o tipo de conteúdo:" 15 50 5 \
                1 "Texto manual" \
                2 "Comando (ps, top, ls, etc.)" \
                3>&1 1>&2 2>&3)
                [ $? -ne 0 ] && continue
            if [ "$tipo" -eq 1 ]; then
                texto=$(dialog --inputbox "Digite o texto:" 15 60 3>&1 1>&2 2>&3)
                echo "$texto" > "$arq"
            else
                cmd=$(dialog --inputbox "Digite o comando (ex: ps, ls, pwd):" 10 50 3>&1 1>&2 2>&3)
                $cmd > "$arq"
            fi

            dialog --msgbox "Arquivo preenchido!" 6 40
            ;;
        6)
            data=$(date)
            dialog --msgbox "Data e hora atuais:\n\n$data" 9 40
            ;;
        7)
            tipo=$(dialog --menu "Alterar o quê?" 10 40 2 \
                1 "Data" \
                2 "Hora" \
                3>&1 1>&2 2>&3)
                [ $? -ne 0 ] && continue

            if [ "$tipo" -eq 1 ]; then
                nova_data=$(dialog --inputbox "Digite nova data (formato AAAA-MM-DD):" 10 50 3>&1 1>&2 2>&3)
                [ $? -ne 0 ] && continue
                sudo date -s "$nova_data"
            else
                nova_hora=$(dialog --inputbox "Digite nova hora (formato HH:MM:SS):" 10 50 3>&1 1>&2 2>&3)
                [ $? -ne 0 ] && continue
                sudo date -s "$nova_hora"
            fi
            dialog --msgbox "Data/Hora alterada!" 6 40
            ;;
        8)
            clear
            exit 0
            ;;
    esac
done


    esac
done
