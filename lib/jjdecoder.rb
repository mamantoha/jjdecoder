require "jjdecoder/version"

class JJDecoder
  def initialize(jj_encoded_data)
    @encoded_str = jj_encoded_data
  end

  def decode
    clean
    startpos, endpos, gv = check_palindrome

    if startpos == endpos
      raise 'No data!'
    end

    data = @encoded_str[startpos...endpos]

    # ex decode string
    b = ['___+', '__$+', '_$_+', '_$$+', '$__+', '$_$+', '$$_+', '$$$+', '$___+', '$__$+', '$_$_+', '$_$$+', '$$__+', '$$_$+', '$$$_+', '$$$$+']

    # lotu
    str_l = '(![]+"")[' + gv + '._$_]+'
    str_o   = gv + '._$+'
    str_t = gv + '.__+'
    str_u = gv + '._+'

    # 0123456789abcdef
    str_hex = gv + '.'

    # s
    str_s = '"'
    gvsig = gv + '.'

    str_quote = '\\\\\\"'
    str_slash = '\\\\\\\\'

    str_lower = '\\\\"+'
    str_upper = '\\\\"+' + gv + '._+'

    str_end  = '"+' # end of s loop

    out = ''
    while data != ''

      # l o t u
      if data.index(str_l) == 0
        data = data[str_l.size..-1]
        out += 'l'
        next
      elsif data.index(str_o) == 0
        data = data[str_o.size..-1]
        out += 'o'
        next
      elsif data.index(str_t) == 0
        data = data[str_t.size..-1]
        out += 't'
        next
      elsif data.index(str_u) == 0
        data = data[str_u.size..-1]
        out += 'u'
        next
      end

      # 0123456789abcdef
      if data.index(str_hex) == 0
        data = data[str_hex.size..-1]

        # check every element of hex decode string for a match
        b.size.times do |i|
          if data.index(b[i]) == 0
            data = data[b[i].size..-1]
            out += i.to_s(16)
            break
          end
        end

        next
      end

      # start of s block
      if data.index(str_s) == 0
        data = data[str_s.size..-1]

        # check if "R
        if data.index(str_upper) == 0 # r4 n >= 128
          data = data[str_upper.size..-1] # skip sig

          ch_str = ''
          2.times do |i| # shouldn't be more than 2 hex chars
            # gv + "."+b[ c ]
            if data.index(gvsig) == 0
              data = data[gvsig.size..-1] # skip gvsig

              b.size.times do |k| # for every entry in b
                if data.index(b[k]) == 0
                  data = data[b[k].size..-1]
                  ch_str = k.to_s(16)
                  break
                end
              end
            else
              break # done
            end
          end

          out += ch_str.to_i(16).chr
          next
        elsif data.index(str_lower) == 0 # r3 check if "R // n < 128
          data = data[str_lower.size..-1] # skip sig

          ch_str = ''
          ch_lotux = ''
          temp = ''
          b_check_r1 = 0
          3.times do |j| # shouldn't be more than 3 octal chars
            if j > 1 # lotu check
              if data.index(str_l) == 0
                data = data[str_l.size..-1]
                ch_lotux = 'l'
                break
              elsif data.index(str_o) == 0
                data = data[str_o.size..-1]
                ch_lotux = 'o'
                break
              elsif data.index(str_t) == 0
                data = data[str_t.size..-1]
                ch_lotux = 't'
                break
              elsif data.index(str_u) == 0
                data = data[str_u.size..-1]
                ch_lotux = 'u'
                break
              end
            end

            # gv + "."+b[ c ]
            if data.index(gvsig) == 0
              temp = data[gvsig.size..-1]
              8.times do |k| # for every entry in b octal
                if temp.index(b[k]) == 0
                  if (ch_str + k.to_s).to_i(8) > 128
                    b_check_r1 = 1
                    break
                  end

                  ch_str += k.to_s
                  data = data[gvsig.size..-1] # skip gvsig
                  data = data[b[k].size..-1]
                  break
                end
              end

              if b_check_r1 == 1
                if data.index(str_hex) == 0 # 0123456789abcdef
                  data = data[str_hex.size..-1]

                  # check every element of hex decode string for a match
                  b.size.times do |i|
                    if data.index(b[i]) == 0
                      data = data[b[i].size..-1]
                      ch_lotux = i.to_s(16)
                      break
                    end
                  end

                  break
                end
              end
            else
              break # done
            end
          end

          out += ch_str.to_i(8).chr + ch_lotux
          next # step out of the while loop
        else # "S ----> "SR or "S+
          # if there is, loop s until R 0r +
          # if there is no matching s block, throw error

          match = 0
          n = nil

          # searching for matching pure s block
          while true
            n = data[0].ord
            if data.index(str_quote) == 0
              data = data[str_quote.size..-1]
              out += '"'
              match += 1
              next
            elsif data.index(str_slash) == 0
              data = data[str_slash.size..-1]
              out += '\\'
              match += 1
              next
            elsif data.index(str_end) == 0 # reached end off S block ? +
              if match == 0
                raise '+ no match S block: ' + data
              end
              data = data[str_end.size..-1]
              break # step out of the while loop
            elsif data.index(str_upper) == 0 # r4 reached end off S block ? - check if "R n >= 128
              if match == 0
                raise 'no match S block n>128: ' + data
              end

              data = data[str_upper.size..-1] # skip sig

              ch_str = ''
              ch_lotux = ''

              10.times do |j| # shouldn't be more than 10 hex chars
                if j > 1 # lotu check
                  if data.index(str_l) == 0
                    data = data[str_l.size..-1]
                    ch_lotux = 'l'
                    break
                  elsif data.index(str_o) == 0
                    data = data[str_o.size..-1]
                    ch_lotux = 'o'
                    break
                  elsif data.index(str_t) == 0
                    data = data[str_t.size..-1]
                    ch_lotux = 't'
                    break
                  elsif data.index(str_u) == 0
                    data = data[str_u.size..-1]
                    ch_lotux = 'u'
                    break
                  end
                end

                # gv + "."+b[ c ]
                if data.index(gvsig) == 0
                  data = data[gvsig.size..-1] # skip gvsig
                  b.size.times do |k| # for every entry in b
                    if data.index(b[k]) == 0
                      data = data[b[k].size..-1]
                      ch_str += k.to_s(16)
                      break
                    end
                  end
                else
                  break # done
                end
              end

              out += ch_str.to_i(16).chr
              break # step out of the while loop
            elsif data.index(str_lower) == 0 # r3 check if "R // n < 128
              if match == 0
                raise 'no match S block n<128: ' + data
              end

              data = data[str_lower.size..-1] # skip sig

              ch_str = ''
              ch_lotux = ''
              temp = ''
              b_check_r1 = 0

              3.times do |j| # shouldn't be more than 3 octal chars
                if j > 1 # lotu check
                  if data.index(str_l) == 0
                    data = data[str_l.size..-1]
                    ch_lotux = 'l'
                    break
                  elsif data.index(str_o) == 0
                    data = data[str_o.size..-1]
                    ch_lotux = 'o'
                    break
                  elsif data.index(str_t) == 0
                    data = data[str_t.size..-1]
                    ch_lotux = 't'
                    break
                  elsif data.index(str_u) == 0
                    data = data[str_u.size..-1]
                    ch_lotux = 'u'
                    break
                  end
                end

                # gv + "."+b[ c ]
                if data.index(gvsig) == 0
                  temp = data[gvsig.size..-1]
                  8.times do |k| # for every entry in b octal
                    if temp.index(b[k]) == 0
                      if (ch_str + k.to_s).to_i(8) > 128
                        b_check_r1 = 1
                        break
                      end

                      ch_str += k.to_s
                      data = data[gvsig.size..-1] # skip gvsig
                      data = data[b[k].size..-1]
                      break
                    end
                  end

                  if b_check_r1 == 1
                    if data.index(str_hex) == 0 # 0123456789abcdef
                      data = data[str_hex.size..-1]
                      # check every element of hex decode string for a match
                      b.size.times do |i|
                        if data.index(b[i]) == 0
                          data = data[b[i].size..-1]
                          ch_lotux = i.to_s(16)
                          break
                        end
                      end
                    end
                  end
                else
                  break # done
                end
              end

              out += ch_str.to_i(8).chr + ch_lotux
              break # step out of the while loop
            elsif (0x21 <= n and n <= 0x2f) or (0x3A <= n and n <= 0x40) or ( 0x5b <= n and n <= 0x60 ) or ( 0x7b <= n and n <= 0x7f )
              out += data[0]
              data = data[1..-1]
              match += 1
            end
          end
          next
        end
      end
      print 'No match : ' + data
      break
    end

    return out
  end

  private

  def clean
    @encoded_str.sub!('^\s+|\s+$', '')
  end

  def check_palindrome
    index = @encoded_str.index('"\'\\"+\'+",')

    if index == 0 # palindrome check
      # locate jjcode
      startpos = @encoded_str.index('$$+"\\""+') + 8
      endpos = @encoded_str.index('"\\"")())()')

      # global variable name used by jjencode
      gv = @encoded_str[@encoded_str.index('"\'\\"+\'+",')+9...@encoded_str.index('=~[]')]
    else
      # global variable name used by jjencode
      gv = @encoded_str[0...@encoded_str.index('=')]

      # locate jjcode
      startpos = @encoded_str.index('"\\""+') + 5
      endpos = @encoded_str.index('"\\"")())()')
    end

    return [startpos, endpos, gv]
  end
end