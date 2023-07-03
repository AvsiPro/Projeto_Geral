import React, {useState} from 'react';
import { InputWrapper, InputField, SearchButton } from './styles';
import { BsSearch } from 'react-icons/bs'
import { ClipLoader } from 'react-spinners';

interface SearchInputProps {
  placeholder: string;
  onSearch: (query: string) => void;
}

const SearchInput: React.FC<SearchInputProps> = ({ placeholder, onSearch }) => {
    const [searchQuery, setSearchQuery] = useState('');
    const [load, setLoad] = useState(false);

    const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
      const query = event.target.value;
      setSearchQuery(query);
    };
  
    const handleButtonSeatch = async() => {
      setLoad(true);
      await onSearch(searchQuery);
      setLoad(false);
    }

    return (
      <InputWrapper>
        <InputField
          type="text"
          value={searchQuery}
          placeholder={placeholder}
          onChange={handleInputChange}
        />
          { load ?
              <ClipLoader
                color={'#000'}
                loading={load}
                size={18}
              />
            :
              <SearchButton color='#fff' onClick={handleButtonSeatch}>
                <BsSearch color={'black'} /> 
              </SearchButton>
          }


      </InputWrapper>
    );
};

export default SearchInput;
