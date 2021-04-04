#!/usr/bin/python3

# Small command-line interface around matplotlib for quick plotting of functions and data
# from the command-line.

import sys
import argparse
import numpy as np
import matplotlib.pyplot as plt
import math
import pandas as pd
from numpy import sin, abs, cos, tan, exp, log, ceil, floor, round

parser = argparse.ArgumentParser(description="Plot functions", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('--minx',type=float, help="Min X", action='store', default=-1.0, required=False)
parser.add_argument('--maxx',type=float, help="Max X", action='store', default=1.0, required=False)
parser.add_argument('--miny',type=float, help="Min Y", action='store', required=False)
parser.add_argument('--maxy',type=float, help="Max Y", action='store', required=False)
parser.add_argument('--steps',type=int, help="Number of data points to compute", action='store', default=100)
parser.add_argument('--width',type=int, help="Figure width", action='store', default=1200)
parser.add_argument('--height',type=int, help="Figure height", action='store', default=1200)
parser.add_argument('--dpi',type=int, help="DPI", action='store', default=96)
parser.add_argument('--title',type=str, help="Title", action='store')
parser.add_argument('--xlabel',type=str, help="X Axis Label", action='store',default='x')
parser.add_argument('--ylabel',type=str, help="Y Axis Label", action='store',default='y')
parser.add_argument('--xvalues',type=str, help="Specify all X values explicitly (comma separated), or a reference to a column by name or index (0-indexed) in the dataset using @0 or @Name syntax", action='store')
parser.add_argument("--names", type=str, help="Names for the functions (semicolon separated)")
parser.add_argument("--format", type=str, help="Format", default="png")
parser.add_argument("--linewidth", type=int, help="Linewidth", default=2)
parser.add_argument("--markersize", type=int, help="Markersize", default=5)
parser.add_argument("--exec", type=str, help="Set variables (normal python expressions)")
parser.add_argument("--style", type=str, help="Plot style (see pyplot format strings), example: - for line plot, . for pointer marker, o for circle marker. Multiple styles (for multiple functions may be separated by a semicolon)", default="-")
parser.add_argument("--nolegend",help="Disable legend", action='store_true', required=False)
parser.add_argument('--readdata','-d',help="Read CSV data from standard input", action='store_true', required=False)
parser.add_argument('functions', nargs='*', help="Functions or references to columns in the data. The latter have the format @1 or @Name (0-indexed)")
args = parser.parse_args() #parsed arguments can be accessed as attributes

if args.readdata:
    data = pd.read_csv(sys.stdin.buffer)
    print(f"Read {len(data)} records",file=sys.stderr)
else:
    data = None

fig = plt.figure(figsize=(args.width/args.dpi,args.height/args.dpi))
if args.title:
    plt.title(args.title)
if args.xlabel:
    plt.xlabel(args.xlabel)
if args.ylabel:
    plt.ylabel(args.ylabel)



if data is not None and not args.xvalues:
    args.xvalues = "@0"

if args.xvalues:
    if args.xvalues[0] == "@":
        if data is None:
            print("ERROR: No data was loaded, use --readdata / -d",file=sys.stderr)
            sys.exit(2)
        col = args.xvalues[1:].strip()
        if col.isnumeric():
            x = data.iloc[:, int(col)]
        else:
            x = data[col]
    else:
        x = np.array( sorted( float(x) for x in args.xvalues.split(",") ))
    plt.xlim(min(x), max(x))
else:
    plt.xlim(args.minx, args.maxx)
    x = np.linspace(args.minx, args.maxx, args.steps)

if args.maxy is not None and not args.miny:
    args.miny = 0
    plt.ylim(args.miny, args.maxy)
elif args.miny is not None and args.maxy is not None:
    plt.ylim(args.miny, args.maxy)
elif data is not None:
    plt.ylim(min(data.iloc[:,1]), max(data.iloc[:,1]))


if args.exec:
    exec(args.exec)

if data is not None and not args.functions:
    args.functions.append("@1")

if args.names:
    names = [ n.strip() for n in args.names.split(";") ]
else:
    names = [ n.strip() for n in args.functions ]

if args.style:
    args.style = [ s.strip() for s in args.style.split(";") ]
    if len(args.style) < len(names): args.style += [args.style[-1]] * (len(names) - len(args.style))


for i, f in enumerate(args.functions):
    if f[0] == '@':
        if data is None:
            print("ERROR: No data was loaded, use --readdata / -d",file=sys.stderr)
            sys.exit(2)
        else:
            col = f[1:].strip()
            if col.isnumeric():
                y = data.iloc[:, int(col)]
            else:
                y = data[col]
    else:
        y = eval(f)
    plt.plot(x, y, args.style[i], linewidth=args.linewidth, markersize=args.markersize, label=names[i])

plt.minorticks_on()

if not args.nolegend:
    plt.legend(loc="upper left")

plt.axhline(0, color='black')
plt.axvline(0, color='black')

plt.grid(which='both', color='#bbbbbb')
plt.savefig(sys.stdout.buffer, format=args.format)

