#!/bin/bash

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

            if [ -e $password_dir/password.txt.gpg ]; then
                gpg -d $password_dir/password.txt.gpg > $password_dir/password.txt 2> /dev/null
                if [ $? -ne 0 ]; then
                    echo "パスワードが違います。"
                    continue
                fi
            else
                touch $password_dir/password.txt
            fi

            if grep -q "^$service_name" $password_dir/password.txt; then
                read -p "すでに同じサービス名で登録されています。上書きしますか？ [y/N]" overwrite_option
                if [ "$overwrite_option" = "y" ]; then
                    grep -v "^$service_name"  $password_dir/password.txt > $password_dir/password.tmp 2> /dev/null
                    mv $password_dir/password.tmp $password_dir/password.txt
                else
                    echo "登録を中止しました。"
                    continue
                fi
            fi

            echo "$service_name:$user_name:$password" >> $password_dir/password.txt
            gpg -c --yes $password_dir/password.txt >> $password_dir/password.txt.gpg 2> /dev/null
            rm $password_dir/password.txt

            echo "パスワードの追加は成功しました。"
            ;;

        'Get Password')
            read -p "サービス名を入力してください：" service_name
            password_record=$(gpg -d $password_dir/password.txt.gpg 2> /dev/null | grep "^$service_name")
            if [ $? -ne 0 ]; then
                echo "パスワードが違います。"
                continue
            fi
            
            if [ $password_record ]; then
                user_name=$(echo $password_record | cut -d : -f 2)
                password=$(echo $password_record | cut -d : -f 3)
                echo "サービス名：$service_name"
                echo "ユーザー名：$user_name"
                echo "パスワード：$password"
            else
                echo "そのサービスは登録されていません。"
            fi
            ;;

        'Exit')
            echo 'Thank you!'
            ;;

        *)
            echo '入力を間違えています。Add Password / Get Password / Exit から入力してください。'
            ;;
    esac
done