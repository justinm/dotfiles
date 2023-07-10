function ssl-genrsa {   
    local usage=(
        "Syntax: $0 -o my-key.pem"
        "        [-o|--out]                         - Optional: Specify the RSA keys file name [Default: private-key.pem]"
        "        [-f|--force]                       - Optional: Specify the RSA keys file name [Default: FALSE]" 
    )

    local out=(private-key.pem)
    local force
    local help

    zmodload zsh/zutil
    # -D pulls parsed flags out of $@
    # -E allows flags/args and positionals to be mixed, which we don't want in this example
    # -F says fail if we find a flag that wasn't defined
    # -M allows us to map option aliases (ie: h=flag_help -help=h)
    # -K allows us to set default values without zparseopts overwriting them
    # Remember that the first dash is automatically handled, so long options are -opt, not --opt
    zparseopts -D -E -F -K -- \
        {h,-help}=help \
        {f,-force}=force \
        {o,-out}:=out \
    || return 1

    [[ "${#help}" != "0" ]] && { print -l $usage && return 0 }
    [[ -z "${out[-1]}" ]] && { echo "No -o|--out was specified" && print -l $usage && return 0 }
    [[ -f "${out[-1]}" ]] && [[ "${#force}" != "1" ]] && { echo "File already exists: ${out[-1]}" && return 1 }

    set -x
    openssl genrsa -out ${out[-1]} 2048
    set +x

    return $?
}

function ssl-csrgen {
    local usage=(
        "Syntax: $0 -d {domain_name}"
        "        [-d|--domain]                      - Specify the CSRs CN field                 [Required]"
        "        [-k|--key]                         - Optional: Specify the CSRs CN field       [Default: {domain}.pem]"
        "        [-o|--out]                         - Optional: Specify the RSA keys file name  [Default: private-key.pem]"
        "        [-f|--force]                       - Optional: Overwrite existing files        [Default: FALSE]"
        "        [--city]                           - Optional: Specify the CSRs L field        [Default: Indianapolis]"
        "        [--company]                        - Optional: Specify the CSRs O field        [Default: ]"
        "        [--country]                        - Optional: Specify the CSRs C field        [Default: US]"
        "        [--organization]                   - Optional: Specify the CSRs L field        [Default: ]"
        "        [--state]                          - Optional: Specify the CSRs L field        [Default: IN]"
        "        [--verbose]                        - Optional: Increase logging                [Default: FALSE]"
        "        [-v|--verify]                      - Optional: Create a verification TXT       [Default: FALSE]"
    )

    local -A args
    local verify
    local verbose
    local force
    local help

    args[--city]="${CSR_CITY:-Indianapolis}"
    args[--company]="${CSR_COMPANY}"
    args[--country]="${CSR_COUNTRY:-US}"
    args[--organization]="${CSR_ORGANIZATION}"
    args[--state]="${CSR_STATE:-IN}"

    zmodload zsh/zutil
    zparseopts -D -E -F -K -M -A args -- \
        -city: \
        -company:: \
        -country: \
        -organization: \
        {d,-domain}: \
        {f,-force}=force \
        {h,-help}=help \
        {k,-key}: \
        {o,-out}: \
        -state: \
        -verbose=verbose \
        {v,-verify}=verify \
    || return 1

    [[ "${#help}" != "0" ]] && { print -l $usage && return 0 }

    local domain="${args[$args[(i)(-d|--domain)]]}"
    local key="${args[$args[(i)(-k|--key)]]:-$domain.pem}"
    local out="${args[$args[(i)(-o|--out)]]:-$domain.csr}"

    local city="$args[$args[(i)--city]]"
    local company="$args[$args[(i)--company]]"
    local country="$args[$args[(i)--country]]"
    local organization="$args[$args[(i)--organization]]"
    local state="$args[$args[(i)--state]]"

    [[ -z "${domain}" ]] && { echo "No -d|--domain was specified" && print -l $usage && return 0 }
    [[ -f "${out}" ]] && [[ "${#force}" != "1" ]] && { echo "File already exists: ${out}" && return 1 }

    [[ ! -f "${key}" ]] && {
        echo "Issuing new private key: $key"
        ssl-genrsa -f --out "$key" || return $?
    }

    local subject="/C=${country}/ST=${state}/L=${city}/O=${company}/OU=${organization}/CN=$domain"

    echo "Signing request for $domain with $key > $out: ${subject}"
    set -x
    openssl req -new -key "$key" -nodes -out "$out" -subj "$subject"
    set +x

    [[ "${#verify}" == "1" ]] && {
        local verify_out=$out.txt

        openssl req -text -noout -verify -in "$out" > "$verify_out"
        [[ "${#verbose}" == "1" ]] && { cat $verify_out }
    }
}
