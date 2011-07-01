a=indgen(3,3)+2
b=indgen(3,3)*10

print, 'before:'
print, a
print
print, b
print

index = where(a gt b)
a[index] = b[index]

print, 'after:'
print, a

end


