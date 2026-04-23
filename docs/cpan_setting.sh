# 若本站不在镜像列表中则将其加入列表首位
if ! (
    perl -MCPAN -e 'CPAN::HandleConfig->load();' \
        -e 'CPAN::HandleConfig->prettyprint("urllist")' |
    grep -qF 'https://mirrors.tuna.tsinghua.edu.cn/CPAN/'
); then
    perl -MCPAN -e 'CPAN::HandleConfig->load();' \
        -e 'CPAN::HandleConfig->edit("urllist", "unshift", "https://mirrors.tuna.tsinghua.edu.cn/CPAN/");' \
        -e 'CPAN::HandleConfig->commit()'
fi

# Perl 5.36 及以上用户还需要关闭 pushy_https
perl -MCPAN -e 'CPAN::HandleConfig->load();' \
    -e 'CPAN::HandleConfig->edit("pushy_https", 0);' \
    -e 'CPAN::HandleConfig->commit()'
