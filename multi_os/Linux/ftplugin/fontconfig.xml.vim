" These files are valid XML
setlocal syntax=xml
" Solve missing DTD errors and provide a proper validator
let b:syntastic_xml_xmllint_tail = '--path /etc/fonts/'
