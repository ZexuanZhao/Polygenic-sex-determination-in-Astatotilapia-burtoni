import argparse
import math

def process_sync_file(input_file, m_denominator, f_denominator, output_file):
    m_denominator = float(m_denominator)
    f_denominator = float(f_denominator)
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            if line.strip() == "":
                continue
            if line.startswith('#'):
                outfile.write(line)
                continue
            
            columns = line.strip().split()
            chrom, pos, ref = columns[0], columns[1], columns[2]
            
            # Process male counts (4th column)
            male_counts = columns[3].split(':')
            scaled_male = []
            for count in male_counts:
                count = float(count)
                if count == 0:
                    scaled_male.append(0)
                else:
                    scaled = round(count / m_denominator)
                    scaled = max(1, scaled)
                    scaled_male.append(scaled)

            processed_male = ":".join([str(x) for x in scaled_male])
            
            # Process female counts (5th column)
            female_counts = columns[4].split(':')
            scaled_female = []
            for count in female_counts:
                count = float(count)
                if count == 0:
                    scaled_female.append(0)
                else:
                    scaled = round(float(count) / f_denominator)
                    scaled = max(1, scaled)
                    scaled_female.append(scaled)
            processed_female = ":".join([str(x) for x in scaled_female])
            
            # Write the processed line
            out_line = f"{chrom}\t{pos}\t{ref}\t{processed_male}\t{processed_female}\n"
            outfile.write(out_line)

def main():
    parser = argparse.ArgumentParser(description='Normalize allele frequencies')
    parser.add_argument('-i', '--input', required=True, help='Input sync file')
    parser.add_argument('-m', '--males', type=float, required=True, help='Denominator of male allele frequency in the 4th column')
    parser.add_argument('-f', '--females', type=float, required=True, help='Denominator of female allele frequency in the 5th column')
    parser.add_argument('-o', '--output', required=True, help='Output sync file')
    args = parser.parse_args()
    process_sync_file(args.input, args.males, args.females, args.output)

if __name__ == '__main__':
    main()
