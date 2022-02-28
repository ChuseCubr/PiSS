import os, argparse

def main(args):
    def _get_top_plvl():
        top_dir_plvl = top_file_plvl = tdp_count = tfp_count = 0
        for root, dirs, files in os.walk(os.getcwd(), topdown=False):
            for dir_name in dirs:
                if dir_name.count("\u200b") == top_dir_plvl:
                    tdp_count += 1
                if dir_name.count("\u200b") > top_dir_plvl:
                    top_dir_plvl = dir_name.count("\u200b")
                    tdp_count = 1

            for file_name in files:
                if file_name.count("\u200b") == top_file_plvl:
                    tfp_count += 1
                if file_name.count("\u200b") > top_file_plvl:
                    top_file_plvl = file_name.count("\u200b")
                    tfp_count = 1

        if ((os.path.isdir(item_name)
                and item_name.count("​") == top_dir_plvl
                and tdp_count == 1)
                or (os.path.isfile(item_name)
                and item_name.count("​") == top_file_plvl
                and tfp_count == 1)):
            return None, None

        return top_dir_plvl, top_file_plvl

    def _pin_top():
        if _get_top_plvl()[0]==None:
            print("File or folder is already pinned to the top")
        else: 
            spaces = []
            if os.path.isdir(item_name):
                for i in range(_get_top_plvl()[0] + 1):
                    spaces.append("​")
            else:
                for i in range(_get_top_plvl()[1] + 1):
                    spaces.append("​")

            spacestr="".join(spaces)
            new_name=spacestr + item_name
            os.rename(item_name, new_name)

    def _pin_remove():
        if item_name.startswith("​"):
            os.rename(item_name, item_name.lstrip("​"))

    def _pin_move_up():
        if _get_top_plvl()[0]==None:
            print("File or folder is already pinned to the top")
        else:
            os.rename(item_name,"".join(["​", item_name]))

    def _pin_move_down():
        if item_name.startswith("​"):
            os.rename(item_name, item_name[1:])

    command = args.command
    item_name = args.item_name

    if command=="t":
        _pin_top()
    elif command=="r":
        _pin_remove()
    elif command=="u":
        _pin_move_up()
    else:
        _pin_move_down()

def handle_args():

    def existing_path(string):
        if os.path.exists(string):
            return string
        else:
            print("File or folder does not exist")
            raise None

    parser = argparse.ArgumentParser(description="""
            Script for pinning and ordering files to the top of a name-ordered folder using zero width spaces.
            Don't use on items that are depended on (program files, etc.)""")
    parser.add_argument("item_name", type=existing_path, action="store", default=os.getcwd())

    command = parser.add_mutually_exclusive_group()
    command.add_argument("--top", "-t",
            action="store_const",
            dest="command",
            const="t",
            default="t",
            help="Pin selected item to the top, even above other pinned items.")
    command.add_argument("--remove", "-r",
            action="store_const",
            dest="command",
            const="r",
            help="Unpin item.")
    command.add_argument("--up", "-u",
            action="store_const",
            dest="command",
            const="u",
            help="Move pin up. For sorting among pinned items.")
    command.add_argument("--down", "-d",
            action="store_const",
            dest="command",
            const="d",
            help="Move pin down. For sorting among pinned items.")

    args = parser.parse_args()
    args.item_name = os.path.split(args.item_name)[1]
    return args

if __name__=="__main__":
    main(handle_args())