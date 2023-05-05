#!/bin/bash

create_decrypted_password_file ()
{
    if [ -e $password_dir/password.txt.gpg ]; then
        gpg -d $password_dir/password.txt.gpg > $password_dir/password.txt 2> /dev/null
        if [ $? -ne 0 ]; then
            rm $password_dir/password.txt
            return 1    
        fi
    else
        touch $password_dir/password.txt
    fi
}

check_overwrite ()
{
    if grep -q "^$service_name:" $password_dir/password.txt; then
        read -p "すでに同じサービス名で登録されています。上書きしますか？ [y/N]" overwrite_option
        if [ "$overwrite_option" = "y" ]; then
            grep -v "^$service_name:"  $password_dir/password.txt > $password_dir/password.tmp 2> /dev/null
            mv $password_dir/password.tmp $password_dir/password.txt
        else
            return 1
        fi
    fi
}

register_encrypted_password ()
{
    echo "$service_name:$user_name:$password" >> $password_dir/password.txt
    gpg -c --yes $password_dir/password.txt >> $password_dir/password.txt.gpg 2> /dev/null
    if [ $? -ne 0 ]; then
        rm $password_dir/password.txt
        echo "パスワードを追加に失敗しました。"
    else
        rm $password_dir/password.txt
        echo "パスワードの追加は成功しました。"
    fi
}

show_password_record ()
{
    user_name=$(echo $password_record | cut -d : -f 2)
    password=$(echo $password_record | cut -d : -f 3)
    echo "サービス名：$service_name"
    echo "ユーザー名：$user_name"
    echo "パスワード：$password"
}


#---Main---
echo "パスワードマネージャーへようこそ！"
password_dir=./.password

while [ ! "$choice" = "Exit" ]
do
    read -p "次の選択肢から入力してください(Add Password / Get Password / Exit)：" choice

    case "$choice" in
        'Add Password')
            read -p "サービス名を入力してください：" service_name
            read -p "ユーザー名を入力してください：" user_name
            read -p "パスワードを入力してください：" password

            create_decrypted_password_file
            if [ $? -ne 0 ]; then
                echo "パスワードが違います。"
                continue
            fi
            
            check_overwrite
            if [ $? -ne 0 ]; then
                echo "登録を中止しました。"
                continue
            fi

            register_encrypted_password
            ;;

        'Get Password')
            read -p "サービス名を入力してください：" service_name

            password_records=$(gpg -d $password_dir/password.txt.gpg 2> /dev/null)
            if [ $? -ne 0 ]; then
                echo "パスワードが違います。"
                continue
            fi

            password_record=$(echo "$password_records" | grep "^$service_name:")
            if [ -z "$password_record" ]; then
                echo "そのサービスは登録されていません。"
                continue
            fi

            show_password_record
            ;;

        'Exit')
            echo 'Thank you!'
            ;;

        *)
            echo '入力を間違えています。Add Password / Get Password / Exit から入力してください。'
            ;;
    esac
done