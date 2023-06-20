import React, {useState} from 'react';
import debounce from 'lodash/debounce';
import { InputWrapper, InputField } from './styles';
import { BsSearch } from 'react-icons/bs'

interface SearchInputProps {
  placeholder: string;
  onSearch: (query: string) => void;
}

const SearchInput: React.FC<SearchInputProps> = ({ placeholder, onSearch }) => {
    const [searchQuery, setSearchQuery] = useState('');

    const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
      const query = event.target.value;
      setSearchQuery(query);
      debouncedSearch(query);
    };
  
    const debouncedSearch = debounce((query: string) => {
      onSearch(query);
    }, 300); // Tempo de espera em milissegundos

  return (
    <InputWrapper>
      <InputField
        type="text"
        value={searchQuery}
        placeholder={placeholder}
        onChange={handleInputChange}
      />

       <BsSearch style={{width:15, height:15, marginLeft:15}} color={'black'} /> 
    </InputWrapper>
  );
};

export default SearchInput;
