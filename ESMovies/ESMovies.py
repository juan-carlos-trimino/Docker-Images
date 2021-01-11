# A module is a Python file that (generally) has only definitions of variables,
# functions, and classes.
# Warning: If you import a module that has already been imported, Python does
#          nothing. It does not re-read the file, even if it has changed. If
#          you want to reload a module, you can use the built-in function
#          reload, but it can be tricky, so the safest thing to do is restart
#          the interpreter and then import the module again.
import decimal
import datetime
import signal
import sys
#
import ESFalcon

#############################
# print_attributes traverses the dictionary and prints each attribute name and
# its corresponding value.
def print_attributes(obj):
    # vars takes an object and returns a dictionary that maps from attribute
    # names (as strings) to their values.
    for attr in vars(obj):
        # getattr takes an object and an attribute name (as a string) and
        # returns the attribute’s value.
        print(attr, getattr(obj, attr))

# find_defining_class takes an object and a method name (as a string) and
# returns the class that provides the definition of the method. It uses the
# mro method to get the list of class objects (types) that will be searched for
# methods. "MRO" stands for "method resolution order", which is the sequence of
# classes Python searches to "resolve" a method name.
def find_defining_class(obj, method_name):
    for t in type(obj).mro():
        if (method_name in t.__dict__):
            return t
####################################################


###############################################################################
# Catch signals
###############################################################################
def catch_ctrl_c(sig, frame):  # Catch SIGINT (CTRL-C)
    print('SIGINT or Ctrl-C detected. Exiting gracefully.')
    sys.exit(0)

###############################################################################
# Entry point
###############################################################################
def main(argv):
    # Setup the Ctrl+C signal handler.
    signal.signal(signal.SIGINT, catch_ctrl_c)
    ESFalcon.main(argv)

# Combining a script and a module is a simple matter of putting a conditional
# test around the controlling function. If it's called as a script, __name__
# (a built-in variable that is set when the program starts) has the value
# '__main__'; otherwise, it has the value of the filename.
if __name__ == '__main__':  # Script?
    main(sys.argv)
else:
    # module-specific initialization code if any
    pass
