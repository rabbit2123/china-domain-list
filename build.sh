#!/bin/bash
# 由domains.txt生成其他文件

DNS="180.76.76.76"
DOMAIN_FILE="domains.txt"
DNSMASQ_FILE="dnsmasq.conf"
DOMAIN_LIST_MD="domain-list.md"
ADGUARD_FILE="adguardhome.txt"


_dnsmasq_file_header() {
cat <<EOF > $DNSMASQ_FILE
# update: $(date)
# repo: https://github.com/rabbit2123/china-domain-list
EOF
}

_domain_list_md_header() {
cat <<EOF > $DOMAIN_LIST_MD
# 网站列表
详细域名列表请看[$DOMAIN_FILE](https://github.com/rabbit2123/china-domain-list/blob/main/domains.txt)。

EOF
}

_write_title() {
    local line_array=($@)
    unset line_array[0]
    local title=${line_array[@]}
    echo "" >> $DNSMASQ_FILE
    echo "# $title" >> $DNSMASQ_FILE
    echo "- $title" >> $DOMAIN_LIST_MD
}

_write_domain() {
    local domain="$1"
    echo "server=/${domain}/${DNS}" >> $DNSMASQ_FILE
    echo "[/${domain}/]${DNS}" >> $ADGUARD_FILE
}

generate_files() {
    _dnsmasq_file_header
    _domain_list_md_header
    echo -n "" > $ADGUARD_FILE

    local tmp_domain_file=$(mktemp)
    cat $DOMAIN_FILE |egrep -v '^ *$|^ *#' > $tmp_domain_file

    while IFS='' read -r line; do
        # 网站名称以 === 开头
        echo "$line" |grep '^ *===' >/dev/null
        if [ "$?" -eq 0 ]; then
            _write_title $line
        else
            _write_domain $line
        fi
    done < "$tmp_domain_file"

    rm $tmp_domain_file
}


if [ "$1" ]; then
    DNS="$1"
fi

generate_files

