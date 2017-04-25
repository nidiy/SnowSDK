
package snow.utils
{
    /** Returns the next power of two that is equal to or bigger than the specified number. */
    public function getNextPowerOfTwo(number:int):int
    {
        if (number > 0 && (number & (number - 1)) == 0)
            return number;
        else
        {
            var result:int = 1;
            while (result < number) result <<= 1;
            return result;
        }
    }
}